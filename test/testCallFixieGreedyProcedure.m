% this script tests callFixieOriginalDamping, run after the main script is
% finished. 
eSurf = [];
n = domLengi;
for iT = 1:n
K = fixie.sti.mtxCell{1} * fixie.pmVal.comb.space(iT, 3) + ...
    fixie.sti.mtxCell{2} * 1;

F = fixie.fce.val;

u = K \ F;

phi = fixie.phi.val;

k = phi' * K * phi;
f = phi' * F;

rv = k\f;
ur = phi * rv;

uq = u(fixie.qoi.dof);
urq = ur(fixie.qoi.dof);

ue = uq - urq;

e = norm(ue, 'fro') / norm(fixie.dis.qoi.trial, 'fro');
eSurf = [eSurf; e];
end
% test passed for all pm points.