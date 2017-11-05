clear variables; clc;
format short;

no.dof_xy = 2;
INPfilename = '/Users/kevin/GoogleDrive/Temp/FE_model/L2H1_dynamics.inp';
MTX_M.file = '/Users/kevin/GoogleDrive/Temp/FE_model/L2H1_dynamics_mtx_MASS1.mtx';
MTX_K.file.I1120S0 = ...
    '/Users/kevin/GoogleDrive/Temp/FE_model/L2H1_dynamics_1120S0_STIF1.mtx';
MTX_K.file.I1021S0 = ...
    '/Users/kevin/GoogleDrive/Temp/FE_model/L2H1_dynamics_1021S0_STIF1.mtx';
MTX_K.file.I1020S1 = ...
    '/Users/kevin/GoogleDrive/Temp/FE_model/L2H1_dynamics_1020S1_STIF1.mtx';
% INPfilename = '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics.inp';
% MTX_M.file = '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_mtx_MASS1.mtx';
% MTX_K.file.I1120S0 = ...
%     '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1120S0_STIF1.mtx';
% MTX_K.file.I1021S0 = ...
%     '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1021S0_STIF1.mtx';
% MTX_K.file.I1020S1 = ...
%     '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1020S1_STIF1.mtx';
loc_string_start = 'nset=Set-lc';
loc_string_end = 'End Assembly';
[cons.node] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
no.cons = length(cons.node);
cons.dof = zeros(no.dof_xy*no.cons, 1);
for i_cons_dof = 1:no.cons
    cons.dof(i_cons_dof*2-1:i_cons_dof*2) = ...
        cons.dof(i_cons_dof*2-1:i_cons_dof*2)+...
        [2*cons.node(i_cons_dof)-1; 2*cons.node(i_cons_dof)];
end
[node, elem] = ABAQUSReadINPGeo(INPfilename);
time.max = 3;
time.step = 1;
no.t_step = length((0:time.step:time.max));
no.incl = 3; %no of inclusions
no.phy = no.incl + 2;
no.pre.hat = 4;

fce.time = 1;
fce.period = 1 * fce.time;
fce.node = 4;
fce.dof = 2 * fce.node;
fce.val = sparse(2 * length(node),  no.t_step);
fce.t = (0 : time.step : fce.time);
fce.trigo = -2 * sin((2 * pi / fce.period) * fce.t);
fce.val(fce.dof, 1:length(fce.t)) = ...
    fce.val(fce.dof, 1:length(fce.t)) + fce.trigo;

%%
domain.length.I1 = 17;
domain.length.I2 = 17;
domain.length.S = 17;
domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;
pm.fix.I3 = 1000;
[pm.space.I1, pm.space.I2, pm.space.comb, pm.mg.I1, pm.mg.I2] = ...
    GSAParameterSpace(domain.length.I1, domain.length.I2, ...
    domain.bond.L.I1, domain.bond.R.I1, domain.bond.L.I2, domain.bond.R.I2);

pm.ori.I1 = log10(pm.space.I1(:, 2));
pm.ori.I2 = log10(pm.space.I2(:, 2));

MTX_M.mtx = ABAQUSReadMTX2DOF(MTX_M.file);
no.dof = length(MTX_M.mtx);
MTX_K.I1120S0 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1120S0, cons.dof, no.dof);
MTX_K.I1021S0 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1021S0, cons.dof, no.dof);
MTX_K.I1020S1 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1020S1, cons.dof, no.dof);

NMcoef = 'average';
phi.ident = eye(size(MTX_M.mtx, 1));
phi.ident = sparse(phi.ident);

%%
pm.trial.val = [1, 1];
pm.trial.idx = (pm.trial.val(2)-1)*domain.length.I1+pm.trial.val(1);
pm.trial.row = pm.space.comb(pm.trial.idx, :);
pm.trial.I1 = pm.trial.row(:, 3);
pm.trial.I2 = pm.trial.row(:, 4);
Dis.inpt = sparse(no.dof, 1);
Vel.inpt = sparse(no.dof, 1);
MTX_K.trial.exact = MTX_K.I1120S0*pm.trial.I1+MTX_K.I1021S0*pm.trial.I2+...
    MTX_K.I1020S1*pm.fix.I3;
MTX_C.mtx = sparse(no.dof, no.dof);
[~, ~, ~, Dis.trial.exact, ~, ~, ~, ~] = ...
    NewmarkBetaReducedMethod(phi.ident, ...
    MTX_M.mtx, MTX_C.mtx, MTX_K.trial.exact, ...
    fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);

%%
% find phi.fre.all (RB for MP).
Nphi.trial = 1;
ERR.store = zeros(no.dof, 1);
ERR.log.store = zeros(no.dof, 1);
sigma.store = [];
ERR.val = 1;
i_cnt_general = 1;
i_cnt_plot = 1;

%% define function handles.

projection = @(x, y) x' * y * x;
summation = @(x1, x2, x3, y1, y2, y3) x1 * y1 + x2 * y2 + x3 * y3;
relativeErr = @(xNum, xInit) norm(xNum, 'fro') / norm(xInit);
relativeErrSq = @(xNum, xInit) (norm(xNum, 'fro')) ^ 2 / (norm(xInit)) ^ 2;
diagsum = @(x) sum(diag(x));
%%
while ERR.val > 0.5
    
    [phi.fre.all, ~, sigma.val] = SVDmod(Dis.trial.exact, Nphi.trial);
    MTX_M.RE.trial.svd = projection(phi.fre.all, MTX_M.mtx);
    MTX_K.RE.trial.svd = projection(phi.fre.all, MTX_K.trial.exact);
    MTX_C.RE.trial.svd = ...
        sparse(length(MTX_K.RE.trial.svd), length(MTX_K.RE.trial.svd));
    fce.RE.trial.svd = phi.fre.all'*fce.val;
    Dis.RE.inpt.svd = sparse(Nphi.trial, 1);
    Vel.RE.inpt.svd = sparse(Nphi.trial, 1);
    
    [~, ~, ~, Dis.trial.svd, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.trial.svd, ...
        MTX_C.RE.trial.svd, MTX_K.RE.trial.svd, ...
        fce.RE.trial.svd, NMcoef, ...
        time.step, time.max, Dis.RE.inpt.svd, Vel.RE.inpt.svd);
    
    ERR.val = (norm(Dis.trial.exact - Dis.trial.svd, 'fro')) / ...
        norm(Dis.trial.exact, 'fro');
    %     ERR.log.val = log10(ERR.val);
    ERR.store(Nphi.trial) = ERR.store(Nphi.trial) + ERR.val;
    %     ERR.log.store(Nphi.trial) = ERR.log.store(Nphi.trial)+ERR.log.val;
    if Nphi.trial >= length(MTX_M.mtx)/2
        warning('size of phi exceed half of DOF number');
    elseif Nphi.trial >= length(MTX_M.mtx)
        error('size of phi exceed DOF number')
    end
    Nphi.trial = Nphi.trial+1;
    
end
sigma.store=[sigma.store; nonzeros(sigma.val)];
Nphi.trial=Nphi.trial-1;

%%
% error response surface for MP.
MTX_K.RE.I1120S0 = projection(phi.fre.all, MTX_K.I1120S0);
MTX_K.RE.I1021S0 = projection(phi.fre.all, MTX_K.I1021S0);
MTX_K.RE.I1020S1 = projection(phi.fre.all, MTX_K.I1020S1);

MTX_M.RE.trial.loop = projection(phi.fre.all, MTX_M.mtx);
MTX_C.RE.trial.loop = ...
    sparse(length(MTX_M.RE.trial.loop), length(MTX_M.RE.trial.loop));

Dis.RE.inpt = sparse(length(MTX_M.RE.trial.loop), 1);
Vel.RE.inpt = sparse(length(MTX_M.RE.trial.loop), 1);

fce.RE.trial.loop = phi.fre.all'*fce.val;

% the error data we need to assess (thus initialize): truth, exact with enriched
% RB, the two error estimate: ehat and ehhat. Error location and max are needed
% for truth and exact with enriched RB, the rest needs max only. 
err.max.store = []; % truth.
err.loc.store = []; 
err.max.store_exactwRB = []; % exact with enriched RB. 
err.loc.store_exactwRB = [];
err.max.store_hat = []; % ehat
err.loc.store_hat = [];
err.max.store_hhat = []; % ehhat
err.loc.store_hhat = [];

err.store.val = zeros(domain.length.I1, domain.length.I2);
h = waitbar(0,'Wait');
steps=size(pm.space.comb, 1);
% each iteration computes one norm error.

for i_trial = 1:size(pm.space.comb, 1)
    waitbar(i_trial / steps)
    %%
    % compute approximation at trial point.
    %%{
    if i_trial == pm.trial.idx
        
        MTX_K.RE.all.appr = ...
        summation(MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
        pm.space.comb(i_trial, 3), pm.space.comb(i_trial, 4), pm.fix.I3);
    
        [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.trial.loop, ...
            MTX_C.RE.trial.loop, MTX_K.RE.all.appr, ...
            fce.RE.trial.loop, NMcoef, ...
            time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
    end
    
    %%
    % compute alpha and ddot_alpha for each PP.
    MTX_K.RE.trial.loop = ...
        summation(MTX_K.RE.I1120S0, MTX_K.RE.I1021S0, MTX_K.RE.I1020S1, ...
        pm.space.comb(i_trial, 3), pm.space.comb(i_trial, 4), pm.fix.I3);
    
    MTX_K.trial.loop = ...
        summation(MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
        pm.space.comb(i_trial, 3), pm.space.comb(i_trial, 4), pm.fix.I3);

    [Dis.RE.trial.loop, Vel.RE.otpt.trial.loop, Acc.RE.otpt.trial.loop, ...
        ~, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.trial.loop, ...
        MTX_C.RE.trial.loop, ...
        MTX_K.RE.trial.loop, ...
        fce.RE.trial.loop, NMcoef, ...
        time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
    %% 
    % compute residual and corresponding error for each PP.err.max.val0
    res.inpt = fce.val-MTX_M.mtx*phi.fre.all*Acc.RE.otpt.trial.loop...
        -MTX_K.trial.loop*phi.fre.all*Dis.RE.trial.loop;
    
    [~, ~, ~, Dis.trial.res, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.trial.loop, ...
        res.inpt, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
    
%     err.val = relativeErr(Dis.trial.res, Dis.trial.exact);
    err.val = relativeErrSq(Dis.trial.res, Dis.trial.exact);
    err.store.val(i_trial) = err.store.val(i_trial) + err.val;
end
close(h)

%%
err.max.val = 0;
[err.max.val0, err.loc.idx.max]=max(err.store.val(:));
pm.iter.row = pm.space.comb(err.loc.idx.max, :);
err.loc.val.max_exactwRB = pm.iter.row(:, 1:2);
err.loc.val.max = pm.iter.row(:, 1:2);

% find error information.
err.max.store = [err.max.store; err.max.val0];
err.max.store_exactwRB = [err.max.store_exactwRB; err.max.val0];
err.max.store_hat = [err.max.store_hat; err.max.val0];
err.max.store_hhat = [err.max.store_hhat, err.max.val0];
err.loc.store = [err.loc.store; err.loc.val.max_exactwRB];
err.loc.store_exactwRB = [err.loc.store_exactwRB; err.loc.val.max_exactwRB];
err.loc.store_hat = [err.loc.store_hat, err.loc.val.max_exactwRB];
err.loc.store_hhat = [err.loc.store_hhat, err.loc.val.max_exactwRB];

%%err.exactwRB
pm.max.loc.I1 = pm.space.I1(err.loc.val.max_exactwRB(1, 1));
pm.max.loc.I2 = pm.space.I2(err.loc.val.max_exactwRB(1, 2));
pm.max.val.I1 = pm.space.comb(err.loc.idx.max, 3);
pm.max.val.I2 = pm.space.comb(err.loc.idx.max, 4);
pm.max.ori.I1 = pm.ori.I1(err.loc.val.max_exactwRB(1, 1));
pm.max.ori.I2 = pm.ori.I2(err.loc.val.max_exactwRB(1, 2));

%%
turnon = 0;
recordon = 0;
draw.row = 2;
draw.col = 4;
font_size.label = 20;
font_size.axis = 12;
progdata.rsurf.store_exactwRB = cell(draw.row*draw.col, 1);
progdata.rsurf.store_exactwRB(i_cnt_general) = {err.store.val};
progdata.rsurf.store = cell(draw.row*draw.col, 1);
progdata.rsurf.store(i_cnt_general) = {err.store.val};
view_angle.x = -30;
view_angle.y = 30;
if turnon == 1
    
    GSAPlotFigure(font_size.label, font_size.axis, ...
        draw.row, draw.col, i_cnt_general, ...
        domain.bond.L.I1, domain.bond.R.I1, ...
        domain.length.I1, domain.bond.L.I2, ...
        domain.bond.R.I2, domain.length.I2, ...
        pm.max.loc.I1, pm.max.loc.I2, ...
        pm.max.ori.I1, pm.max.ori.I2, ...
        err.max.val0, err.max.val, err.store.val, cool, ...
        view_angle.x, view_angle.y);
    
end
