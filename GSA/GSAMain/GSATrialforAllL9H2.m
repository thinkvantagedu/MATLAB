clear variables; clc;
format short;
% RB: reduced basis.
% MP: magic point.
% PP: parameter point.

% core_num = 4;
% pool = parpool(core_num);

addpath('/home/xiaohan/Desktop/Temp');
addpath('/home/xiaohan/Desktop/Temp/FE_model');
addpath('/home/xiaohan/Desktop/Temp/MATLAB');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/GSA');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/GSA/GSAMain');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/ABAQUS_MOR');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/Newmark Method');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/Lagrange Interpolation');
addpath('/home/xiaohan/Desktop/Temp/MATLAB/OtherFunctions');

no.dof_xy = 2;
INPfilename = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics.inp';
loc_string_start = 'nset=Set-lc';
loc_string_end = 'Elset, elset=Set-lc';
[cons.node] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
no.cons = length(cons.node);
cons.dof = zeros(no.dof_xy*no.cons, 1);
for i_cons_dof = 1:no.cons
    cons.dof(i_cons_dof*2-1:i_cons_dof*2) = cons.dof(i_cons_dof*2-1:i_cons_dof*2)+...
        [2*cons.node(i_cons_dof)-1; 2*cons.node(i_cons_dof)];
end
[node, elem] = ABAQUSReadINPGeo(INPfilename);
MTX_M.file = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_MASS1.mtx';
MTX_K.file.I1120S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I11_I20_IS0_STIF1.mtx';
MTX_K.file.I1021S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I10_I21_IS0_STIF1.mtx';
MTX_K.file.I1020S1 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I10_I20_IS1_STIF1.mtx';

time.max = 6;
time.step = 0.1;
no.t_step = length((0:time.step:time.max));
no.incl = 3; %no of inclusions
no.phy = no.incl+2;
no.ord = 'linear';
switch no.ord
    case 'linear'
        no.pre = 4;
    case 'quadratic'
        no.pre = 9;
end

fce.time = 4;
fce.period = 2*fce.time;
fce.node = 4;
fce.dof = 2*fce.node;
fce.val = sparse(2*length(node),  no.t_step);
fce.t = (0:time.step:fce.time);
fce.trigo = -sin((2*pi/fce.period)*fce.t);
fce.val(fce.dof, 1:length(fce.t)) = fce.val(fce.dof, 1:length(fce.t))+fce.trigo;

%%
domain.length.I1 = 25;
domain.length.I2 = 25;
domain.length.S = 25;
domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;
pm.fix.I3 = 1000;
[pm.space.I1, pm.space.I2, pm.space.comb, pm.mg.I1, pm.mg.I2] = GSAParameterSpace...
    (domain.length.I1, domain.length.I2, ...
    domain.bond.L.I1, domain.bond.R.I1, domain.bond.L.I2, domain.bond.R.I2);

MTX_M.mtx = ABAQUSReadMTX2DOF(MTX_M.file);
no.dof = length(MTX_M.mtx);
MTX_K.I1120S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1120S0);
MTX_K.I1120S0(cons.dof, :) = 0;
MTX_K.I1120S0(:, cons.dof) = 0;
MTX_K.I1021S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1021S0);
MTX_K.I1021S0(cons.dof, :) = 0;
MTX_K.I1021S0(:, cons.dof) = 0;
MTX_K.I1020S1 = ABAQUSReadMTX2DOF(MTX_K.file.I1020S1);
MTX_K.I1020S1(cons.dof, :) = 0;
MTX_K.I1020S1(:, cons.dof) = 0;

NMcoef = 'average';
phi.ident = eye(size(MTX_M.mtx, 1));
phi.ident = sparse(phi.ident);

%%
pm.trial.val = [1, 25];
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
    NewmarkBetaReducedMethod(phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.trial.exact, ...
    fce.val, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);

%%
% find phi.fre.all (RB for MP).
Nphi.trial = 1;
ERR.store = zeros(no.dof, 1);
ERR.log.store = zeros(no.dof, 1);
sigma.store = [];

ERR.val = 1;
while ERR.val>1e-3
    
    [phi.fre.all, ~, sigma.val] = SVDmod(Dis.trial.exact, Nphi.trial);
    MTX_M.RE.trial.svd = phi.fre.all'*MTX_M.mtx*phi.fre.all;
    MTX_K.RE.trial.svd = phi.fre.all'*MTX_K.trial.exact*phi.fre.all;
    MTX_C.RE.trial.svd = sparse(length(MTX_K.RE.trial.svd), length(MTX_K.RE.trial.svd));
    fce.RE.trial.svd = phi.fre.all'*fce.val;
    Dis.RE.inpt.svd = sparse(Nphi.trial, 1);
    Vel.RE.inpt.svd = sparse(Nphi.trial, 1);
    
    [~, ~, ~, Dis.trial.svd, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.trial.svd, MTX_C.RE.trial.svd, MTX_K.RE.trial.svd, ...
        fce.RE.trial.svd, NMcoef, time.step, time.max, Dis.RE.inpt.svd, Vel.RE.inpt.svd);
    
    ERR.val = abs((norm(Dis.trial.exact-Dis.trial.svd, 'fro'))/...
        norm(Dis.trial.exact, 'fro'));
    %     ERR.log.val = log10(ERR.val);
    ERR.store(Nphi.trial) = ERR.store(Nphi.trial)+ERR.val;
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
MTX_K.RE.I1120S0 = phi.fre.all'*MTX_K.I1120S0*phi.fre.all;
MTX_K.RE.I1021S0 = phi.fre.all'*MTX_K.I1021S0*phi.fre.all;
MTX_K.RE.I1020S1 = phi.fre.all'*MTX_K.I1020S1*phi.fre.all;

MTX_M.RE.trial.loop = phi.fre.all'*MTX_M.mtx*phi.fre.all;
MTX_C.RE.trial.loop = sparse(length(MTX_M.RE.trial.loop), length(MTX_M.RE.trial.loop));

Dis.RE.inpt = sparse(length(MTX_M.RE.trial.loop), 1);
Vel.RE.inpt = sparse(length(MTX_M.RE.trial.loop), 1);

fce.RE.trial.loop = phi.fre.all'*fce.val;

err.max.store=[];
err.max.log_store=[];
err.loc.store=[];

err.max.store=[];
err.max.log_store=[];
err.loc.store=[];

err.store.val = zeros(domain.length.I1, domain.length.I2);
err.log_store.val = zeros(domain.length.I1, domain.length.I2);
h = waitbar(0,'Wait');
steps=size(pm.space.comb, 1);
% each iteration computes one norm error.
tic
for i_trial = 1:size(pm.space.comb, 1)
% for i_trial = 1:601
    waitbar(i_trial / steps)
    %%
    % compute approximation at trial point.
    %%{
    if i_trial == pm.trial.idx
        MTX_K.RE.all.appr = MTX_K.RE.I1120S0*pm.space.comb(i_trial, 3)+...
            MTX_K.RE.I1021S0*pm.space.comb(i_trial, 4)+...
            MTX_K.RE.I1020S1*pm.fix.I3;
        
        [~, ~, ~, Dis.all.appr, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi.fre.all, MTX_M.RE.trial.loop, MTX_C.RE.trial.loop, MTX_K.RE.all.appr, ...
            fce.RE.trial.loop, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
    end
    
    %%
    % compute alpha and ddot_alpha for each PP.
    MTX_K.RE.trial.loop = MTX_K.RE.I1120S0*pm.space.comb(i_trial, 3)+...
        MTX_K.RE.I1021S0*pm.space.comb(i_trial, 4)+...
        MTX_K.RE.I1020S1*pm.fix.I3;
    MTX_K.trial.loop = MTX_K.I1120S0*pm.space.comb(i_trial, 3)+...
        MTX_K.I1021S0*pm.space.comb(i_trial, 4)+...
        MTX_K.I1020S1*pm.fix.I3;
    
    [Dis.RE.trial.loop, Vel.RE.otpt.trial.loop, Acc.RE.otpt.trial.loop, ~, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethod...
        (phi.fre.all, MTX_M.RE.trial.loop, MTX_C.RE.trial.loop, MTX_K.RE.trial.loop, ...
        fce.RE.trial.loop, NMcoef, time.step, time.max, Dis.RE.inpt, Vel.RE.inpt);
    %%
    % compute residual and corresponding error for each PP.err.max.val0
    res.inpt = fce.val-MTX_M.mtx*phi.fre.all*Acc.RE.otpt.trial.loop...
        -MTX_K.trial.loop*phi.fre.all*Dis.RE.trial.loop;
    
    [~, ~, ~, Dis.trial.res, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi.ident, MTX_M.mtx, MTX_C.mtx, MTX_K.trial.loop, ...
        res.inpt, NMcoef, time.step, time.max, Dis.inpt, Vel.inpt);
    
%     err.val = norm(Dis.trial.res, 'fro')/norm(Dis.trial.exact, 'fro');
    err.val = (norm(Dis.trial.res, 'fro'))^2/(norm(Dis.trial.exact, 'fro'))^2;
    err.store.val(i_trial) = err.store.val(i_trial)+err.val;
    err.log_store.val(i_trial) = err.log_store.val(i_trial)+log10(err.val);
end
close(h)
toc
%%
[err.max.val0, err.loc.idx.max]=max(err.store.val(:));
err.max.store=[err.max.store; err.max.val0];
err.max.log_store=[err.max.log_store log10(err.max.val0)];
pm.iter.row=pm.space.comb(err.loc.idx.max, :);
err.loc.val.max=pm.iter.row(:, 1:2);
err.loc.store=[err.loc.store; err.loc.val.max];

%%
turnon = 1;
draw.row = 2;
draw.col = 3;
if turnon == 1
    font_size = 10;
%     titl.err=sprintf('Error response surface, initial point = [%d %d]', ...
%         pm.trial.val(1), pm.trial.val(2));
%     titl.log_err=sprintf('Log error response surface, initial point = [%d %d]', ...
%         pm.trial.val(1), pm.trial.val(2));
    figureFullScreen('Name','Full screen figure size');
%     suptitle(titl.err)
    subplot(draw.row, draw.col, 1)
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.store.val');
    set(gca,'fontsize',font_size)
    xlabel('inclusion 1', 'FontSize', font_size)
    ylabel('inclusion 2', 'FontSize', font_size)
    zlabel('error', 'FontSize', font_size)
%     set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
    set(gca, 'ZScale', 'log')
    axi.err=sprintf('');
    axis([1 2 1 2])
    axi.lim = [0, err.max.val0];
    zlim(axi.lim)
    axis square
    view([-60 30])
    set(legend,'FontSize',font_size);
%     figure(2)
%     suptitle(titl.log_err)
%     subplot(draw.row, draw.col, 1)
%     surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
%         linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), err.log_store.val');
%     xlabel('inclusion 1', 'FontSize', 18)
%     ylabel('inclusion 2', 'FontSize', 18)
%     zlabel('log error', 'FontSize', 18)
%     set(gca,'fontsize',18)
%     set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
%     set(gca, 'ZScale', 'log')
%     axis([1 2 1 2])
%     axi.log_lim = [-3.5, log10(err.max.val0)];
%     zlim(axi.log_lim)
%     axis square
%     view([-60 30])
%     set(legend,'FontSize',18);
    disp(err.max.val0)
    disp(err.loc.val.max)
end