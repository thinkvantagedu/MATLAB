% this script test error of 1. classical Greedy. 
% With 1 pm point, run after running main scripts (callFixieOriginal).

%% case 1: classical Greedy.
pmTest = fixie.pmVal.i.trial;

M = fixie.mas.mtx;
C = fixie.dam.mtx;
Kinc = fixie.sti.mtxCell{1};
Kmtx = fixie.sti.mtxCell{2};
K = Kinc * pmTest + Kmtx * 1;
F = fixie.fce.val;
nd = size(M, 1);

phiId = eye(nd);
U0 = zeros(nd, 1);
V0 = zeros(nd, 1);
dt = fixie.time.step;
maxt = fixie.time.max;
% compute exact solution for the test point.
[~, ~, ~, U, ~, ~, ~, ~] = ...
    NewmarkBetaReducedMethod(phiId, M, C, K, F, 'average', dt, maxt, U0, V0);
% compute the basis.
[phi, singRatio] = basisCompressionRatio(U, 0.8);
nr = size(phi, 2);
% compute the reduced variable.
m = phi' * M * phi;
c = phi' * C * phi;
kinc = phi' * Kinc * phi;
kmtx = phi' * Kmtx * phi;
k = kinc * pmTest + kmtx * 1;
f = phi' * F;
u0 = zeros(nr, 1);
v0 = zeros(nr, 1);
[u, ~, ~, ~, ~, ~, ~, ~] = ...
    NewmarkBetaReducedMethod(phi, m, c, k, f, 'average', dt, maxt, u0, v0);

% compute approximation for the test point.
Ur = phi * u;

% compare 2 errors. 
[l, s, r] = svd(U, 0);
Ursvd = l(:, 1:nr) * s(1:nr, 1:nr) * r(:, 1:nr)';
errsvd = norm((U - Ursvd), 'fro') / norm(fixie.dis.trial, 'fro');
errrb = norm(U - Ur, 'fro') / norm(fixie.dis.trial, 'fro');