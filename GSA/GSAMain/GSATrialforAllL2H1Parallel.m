clear variables; clc;
format short;
tic

noDof_xy = 2;
INPfilename = '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics.inp';
locStringStart = 'nset=Set-lc';
locStringEnd = 'End Assembly';
[cons.node] = ABAQUSReadINPCons(INPfilename, locStringStart, locStringEnd);
no.cons = length(cons.node);
cons.dof = zeros(noDof_xy * no.cons, 1);
for iConsDof = 1:no.cons
    cons.dof(iConsDof * 2 - 1:iConsDof * 2) = ...
        cons.dof(iConsDof * 2-1:iConsDof * 2)+...
        [2 * cons.node(iConsDof)-1; 2*cons.node(iConsDof)];
end
[node, elem] = ABAQUSReadINPGeo(INPfilename);
MTX_M.file = '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_mtx_MASS1.mtx';
MTX_K.file.I1120S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1120S0_STIF1.mtx';
MTX_K.file.I1021S0 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1021S0_STIF1.mtx';
MTX_K.file.I1020S1 = ...
    '/home/xiaohan/Desktop/Temp/FE_model/L2H1_dynamics_1020S1_STIF1.mtx';

tMax = 12;
tStep = 0.5;
noTstep = length((0 : tStep : tMax));
no.incl = 3; %no of inclusions
noPhy = no.incl + 2;
no.pre.hat = 4;

fce.time = 2;
fce.period = 1 * fce.time;
fce.node = 4;
fce.dof = 2 * fce.node;
Fval = sparse(2 * length(node),  noTstep);
fce.t = (0:tStep:fce.time);
fce.trigo = -sin((2 * pi / fce.period) * fce.t);
Fval(fce.dof, 1:length(fce.t)) = Fval(fce.dof, 1:length(fce.t)) + fce.trigo;

%%
domain.length.I1 = 33;
domain.length.I2 = 33;
domain.length.S = 33;
domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;
pmI3 = 1000;
[pm.space.I1, pm.space.I2, pmComb, ~, ~] = ...
    GSAParameterSpace...
    (domain.length.I1, domain.length.I2, ...
    domain.bond.L.I1, domain.bond.R.I1, domain.bond.L.I2, domain.bond.R.I2);

pm.ori.I1 = log10(pm.space.I1(:, 2));
pm.ori.I2 = log10(pm.space.I2(:, 2));

Mmtx = ABAQUSReadMTX2DOF(MTX_M.file);
noDof = length(Mmtx);
K1120S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1120S0);
K1120S0(cons.dof, :) = 0;
K1120S0(:, cons.dof) = 0;
K1021S0 = ABAQUSReadMTX2DOF(MTX_K.file.I1021S0);
K1021S0(cons.dof, :) = 0;
K1021S0(:, cons.dof) = 0;
K1020S1 = ABAQUSReadMTX2DOF(MTX_K.file.I1020S1);
K1020S1(cons.dof, :) = 0;
K1020S1(:, cons.dof) = 0;

NMcoef = 'average';
phiID = eye(size(Mmtx, 1));
phiID = sparse(phiID);

%%
pm.trial.val = [1, 1];
pmTriIdx = (pm.trial.val(2)-1) * domain.length.I1 + pm.trial.val(1);
pm.trial.row = pmComb(pmTriIdx, :);
pm.trial.I1 = pm.trial.row(:, 3);
pm.trial.I2 = pm.trial.row(:, 4);
disInpt = sparse(noDof, 1);
velInpt = sparse(noDof, 1);
MTX_K.trial.exact = K1120S0 * pm.trial.I1+K1021S0 * pm.trial.I2 + ...
    K1020S1 * pmI3;
Cmtx = sparse(noDof, noDof);
[~, ~, ~, disTrialExact, ~, ~, ~, ~] = NewmarkBetaReducedMethod(phiID, ...
    Mmtx, Cmtx, MTX_K.trial.exact, Fval, ...
    NMcoef, tStep, tMax, disInpt, velInpt);

%%
% find phiPAR (RB for MP).
Nphi.trial = 1;
ERR.store = zeros(noDof, 1);
ERR.log.store = zeros(noDof, 1);
sigma.store = [];
ERR.val = 1;
iCntGeneral = 1;
iCntPlot = 1;
while ERR.val > 1e-2
    
    [phiPAR, ~, sigma.val] = SVDmod(disTrialExact, Nphi.trial);
    MTX_M.RE.trial.svd = phiPAR' * Mmtx * phiPAR;
    MTX_K.RE.trial.svd = phiPAR' * MTX_K.trial.exact * phiPAR;
    MTX_C.RE.trial.svd = ...
        sparse(length(MTX_K.RE.trial.svd), length(MTX_K.RE.trial.svd));
    fce.RE.trial.svd = phiPAR' * Fval;
    disReInpt.svd = sparse(Nphi.trial, 1);
    velReInpt.svd = sparse(Nphi.trial, 1);
    
    [~, ~, ~, Dis.trial.svd, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiPAR, MTX_M.RE.trial.svd, ...
        MTX_C.RE.trial.svd, MTX_K.RE.trial.svd, ...
        fce.RE.trial.svd, NMcoef, ...
        tStep, tMax, disReInpt.svd, velReInpt.svd);
    
    ERR.val = abs((norm(disTrialExact-Dis.trial.svd, 'fro'))/...
        norm(disTrialExact, 'fro'));
    %     ERR.log.val = log10(ERR.val);
    ERR.store(Nphi.trial) = ERR.store(Nphi.trial) + ERR.val;
    %     ERR.log.store(Nphi.trial) = ERR.log.store(Nphi.trial)+ERR.log.val;
    if Nphi.trial >= length(Mmtx) / 2
        warning('size of phi exceed half of DOF number');
    elseif Nphi.trial >= length(Mmtx)
        error('size of phi exceed DOF number')
    end
    Nphi.trial = Nphi.trial+1;
    
end
sigma.store = [sigma.store; nonzeros(sigma.val)];
Nphi.trial = Nphi.trial-1;

%%
% error response surface for MP.
Kre1120S0 = phiPAR' * K1120S0 * phiPAR;
Kre1021S0 = phiPAR' * K1021S0 * phiPAR;
Kre1020S1 = phiPAR' * K1020S1 * phiPAR;

MreLoop = phiPAR' * Mmtx * phiPAR;
CreLoop = sparse(length(MreLoop), length(MreLoop));

disReInpt = sparse(length(MreLoop), 1);
velReInpt = sparse(length(MreLoop), 1);

FreLoop = phiPAR' * Fval;

err.max.store=[];
err.max.log_store=[];
err.loc.store=[];

err_sqr.max.store=[];
err_sqr.max.log_store=[];
err_sqr.loc.store=[];

errStoreVal = zeros(domain.length.I1, domain.length.I2);



%%
% each iteration computes one norm error.
pmCombI1 = pmComb(:, 3);
pmCombI2 = pmComb(:, 4);
disAppr = zeros(noDof, noTstep);
parfor iTrial = 1:size(pmComb, 1)
    %%
    % compute approximation at trial point.
    %%{
    if iTrial == pmTriIdx
        KreAppr = Kre1120S0 * pmCombI1(iTrial) + ...
            Kre1021S0 * pmCombI2(iTrial) + Kre1020S1 * pmI3;
        
        [~, ~, ~, disApprTemp, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phiPAR, MreLoop, CreLoop, KreAppr, ...
            FreLoop, NMcoef, tStep, tMax, disReInpt, velReInpt);
        disAppr = disAppr + disApprTemp;
    end
    
    %%
    % compute alpha and ddot_alpha for each PP.
    KreLoop = Kre1120S0 * pmCombI1(iTrial) + ...
        Kre1021S0 * pmCombI2(iTrial) + Kre1020S1 * pmI3;
    KLoop = K1120S0*pmCombI1(iTrial) + ...
        K1021S0 * pmCombI2(iTrial) + K1020S1 * pmI3;
    
    [disReLoop, velReLoop, accReLoop, ~, ~, ~, ~, ~] = ...
        NewmarkBetaReducedMethod(phiPAR, MreLoop, CreLoop, KreLoop, ...
        FreLoop, NMcoef, tStep, tMax, disReInpt, velReInpt);
    %% 
    % compute residual and corresponding error for each PP.err.max.val0
    resInpt = Fval - Mmtx * phiPAR * accReLoop - ...
        KLoop * phiPAR * disReLoop;
    
    [~, ~, ~, disRes, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiID, Mmtx, Cmtx, KLoop, ...
        resInpt, NMcoef, tStep, tMax, disInpt, velInpt);
    
%     err.val = norm(disRes, 'fro')/norm(disTrialExact, 'fro');
    errVal = (norm(disRes, 'fro')) ^ 2 / (norm(disTrialExact, 'fro')) ^ 2;
    errStoreVal(iTrial) = errStoreVal(iTrial) + errVal;
    
end
toc
%%
err.max.val = 0;
[err.max.val0, err.loc.idx.max] = max(errStoreVal(:));
err.max.store = [err.max.store; err.max.val0];
err.max.log_store = [err.max.log_store log10(err.max.val0)];
pm.iter.row = pmComb(err.loc.idx.max, :);
err.loc.val.max = pm.iter.row(:, 1:2);
err.loc.store = [err.loc.store; err.loc.val.max];

pm.max.loc.I1 = pm.space.I1(err.loc.val.max(1, 1));
pm.max.loc.I2 = pm.space.I2(err.loc.val.max(1, 2));
pm.max.val.I1 = pmComb(err.loc.idx.max, 3);
pm.max.val.I2 = pmComb(err.loc.idx.max, 4);
pm.max.ori.I1 = pm.ori.I1(err.loc.val.max(1, 1));
pm.max.ori.I2 = pm.ori.I2(err.loc.val.max(1, 2));


%%
turnon = 1;
recordon = 0;
draw.row = 2;
draw.col = 3;
font_size.label = 20;
font_size.axis = 12;
progdata.rsurf.store = cell(draw.row*draw.col, 1);
progdata.rsurf.store(iCntGeneral) = {errStoreVal};
view_angle.x = -30;
view_angle.y = 30;
if turnon == 1
    
    GSAPlotFigure(font_size.label, font_size.axis, ...
        draw.row, draw.col, iCntGeneral, ...
        domain.bond.L.I1, domain.bond.R.I1, ...
        domain.length.I1, domain.bond.L.I2, ...
        domain.bond.R.I2, domain.length.I2, ...
        pm.max.loc.I1, pm.max.loc.I2, ...
        pm.max.ori.I1, pm.max.ori.I2, ...
        err.max.val0, err.max.val, errStoreVal, cool, ...
        view_angle.x, view_angle.y);
    
end