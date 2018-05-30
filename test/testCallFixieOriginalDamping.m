% this script tests callFixieOriginalDamping, run after the main script is
% finished. 
M = fixie.mas.mtx;
K = fixie.sti.mtxCell{1} * fixie.pmVal.iter{1} + fixie.sti.mtxCell{2} * ...
    fixie.pmVal.iter{2};
C = fixie.pmVal.damp.space(end) * K;

F = fixie.fce.val;

nd = length(F);
dt = fixie.time.step;
mt = fixie.time.max;

phiI = ones(nd, nd);

u0 = zeros(nd, 1);
v0 = zeros(nd, 1);

[~, ~, ~, u, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, F, 'average', dt, mt, u0, v0);

rv = fixie.dis.re.reVar;
phi = fixie.phi.val(:, 1:end - 1);

ur = phi * rv;

uq = u(fixie.qoi.dof, fixie.qoi.t);
urq = ur(fixie.qoi.dof, fixie.qoi.t);

e = norm(uq - urq, 'fro') / norm(fixie.dis.qoi.trial);