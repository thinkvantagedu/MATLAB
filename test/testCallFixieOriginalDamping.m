% this script tests callFixieOriginalDamping, run after the main script is
% finished. 
ppick = 15;
M = fixie.mas.mtx;
K = fixie.sti.mtxCell{1} * fixie.pmVal.comb.space(ppick, 4) + ...
    fixie.sti.mtxCell{2} * 1;
C = fixie.pmVal.comb.space(ppick, 5) * K;

F = fixie.fce.val;

nd = length(F);
dt = fixie.time.step;
mt = fixie.time.max;

phiI = eye(nd);

u0 = zeros(nd, 1);
v0 = zeros(nd, 1);

[~, ~, ~, u, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, F, 'average', dt, mt, u0, v0);

phi = fixie.phi.val;

m = phi' * M * phi;
c = phi' * C * phi;
k = phi' * K * phi;
f = phi' * F;

nr = size(m, 1);
u0r = zeros(nr, 1);
v0r = zeros(nr, 1);

[rv, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dt, mt, u0r, v0r);

ur = phi * rv;

uq = u(fixie.qoi.dof, fixie.qoi.t);
urq = ur(fixie.qoi.dof, fixie.qoi.t);

ue = uq - urq;

e = norm(ue, 'fro') / norm(fixie.dis.qoi.trial, 'fro');

% test passed for all pm points.