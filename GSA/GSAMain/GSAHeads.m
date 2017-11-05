%% define function handles.

projection = @(x, y) x' * y * x;
summation = @(x1, x2, x3, y1, y2, y3) x1 * y1 + x2 * y2 + x3 * y3;
relativeErr = @(xNum, xInit) norm(xNum, 'fro') / norm(xInit);
relativeErrSq = @(xNum, xInit) ...
    (norm(xNum, 'fro')) ^ 2 / (norm(xInit, 'fro')) ^ 2;
diagsum = @(x) sum(diag(x));

%% input data.
time.max = 5;
time.step = 1;
no.t_step = length((0:time.step:time.max));
no.incl = 3; % no of inclusions
no.phy = no.incl + 2;
no.pre.hat = 4;
fce.time = 1;
fce.period = 1 * fce.time;
if strcmp(trialName, 'l2h1') == 1
    fce.node = 4;
else
    fce.node = 4;
end
domain.length.I1 = 17;
domain.length.I2 = 17;
domain.length.S = 17;
domain.bond.L.I1 = 1;
domain.bond.R.I1 = 2;
domain.bond.L.I2 = 1;
domain.bond.R.I2 = 2;


no.dof_xy = 2;
[cons.node] = ABAQUSReadINPCons(INPfilename, loc_string_start, loc_string_end);
no.cons = length(cons.node);
cons.dof = zeros(no.dof_xy * no.cons, 1);
for i_cons_dof = 1:no.cons
    cons.dof(i_cons_dof * 2-1:i_cons_dof * 2) = ...
        cons.dof(i_cons_dof * 2-1:i_cons_dof * 2)+...
        [2 * cons.node(i_cons_dof)-1; 2 * cons.node(i_cons_dof)];
end

[node, elem] = ABAQUSReadINPGeo(INPfilename);

fce.dof = 2 * fce.node;
fce.val = sparse(2 * length(node),  no.t_step);
fce.t = (0 : time.step : fce.time);
fce.trigo = -sin((2 * pi / fce.period) * fce.t);
fce.val(fce.dof, 1:length(fce.t)) = ...
    fce.val(fce.dof, 1:length(fce.t)) + fce.trigo;

[pmVal, pm] = GSAParameterSpace(domain);
pmVal.fix.I3 = 1000;
pmExp.ori.I1 = log10(pmVal.space.I1(:, 2));
pmExp.ori.I2 = log10(pmVal.space.I2(:, 2));

MTX_M.mtx = ABAQUSReadMTX2DOF(MTX_M.file);
no.dof = length(MTX_M.mtx);
MTX_K.I1120S0 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1120S0, cons.dof, no.dof);
MTX_K.I1021S0 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1021S0, cons.dof, no.dof);
MTX_K.I1020S1 = ABAQUSReadMTX2DOFBCMod(MTX_K.file.I1020S1, cons.dof, no.dof);

NMcoef = 'average';


%% first exact solution
pmLoc.trial.val = [1, 1];
pmLoc.trial.idx = (pmLoc.trial.val(2) - 1) * domain.length.I1 + pmLoc.trial.val(1);
pmLoc.trial.row = pm.space.comb(pmLoc.trial.idx, :);
pmVal.trial.I1 = pmLoc.trial.row(:, 3);
pmVal.trial.I2 = pmLoc.trial.row(:, 4);
Dis.inpt = sparse(no.dof, 1);
Vel.inpt = sparse(no.dof, 1);

MTX_K.trial.exact = summation...
    (MTX_K.I1120S0, MTX_K.I1021S0, MTX_K.I1020S1, ...
    pmVal.trial.I1, pmVal.trial.I2, pmVal.fix.I3);
MTX_C.mtx = sparse(no.dof, no.dof);


