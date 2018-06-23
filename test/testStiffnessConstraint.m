disVec = fixie.dis.trial(:, 340);
node = fixie.node.all;
elem = fixie.elem.all;

plotDeformedStruct(node, elem, disVec, 1, 0)

k1 = fixie.sti.mtxCell{1};
k2 = fixie.sti.mtxCell{2};

testPm = [3 5];
% non-constraint stiffness matrix.
knon = k1 * testPm(1) + k2 * 1;

% c = k1 * testPm(1) * testPm(2);

c = fixie.dam.mtx;
m = fixie.mas.mtx;

f = fixie.fce.val;

dT = 0.1;
mT = 4.9;

u0 = zeros(fixie.no.dof, 1);
v0 = zeros(fixie.no.dof, 1);

phi = eye(fixie.no.dof);

[~, ~, ~, unon, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, knon, f, 'average', dT, mT, u0, v0);

% constraint stiffness matrix.
kcon = knon;
cons = [fixie.cons.dof{:}];
cons = cons(:);
kcon(cons, :) = 0;
kcon(:, cons) = 0;
kcon(cons, cons) = 1;

[~, ~, ~, ucon, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, kcon, f, 'average', dT, mT, u0, v0);

% test result: these elements at diagonal lines of constraint dofs doesn't
% affect final results.
