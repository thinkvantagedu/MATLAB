% this script test ONERA_M60 wing exact error.

nd = canti.no.dof;
nr = canti.no.rb;

qd = canti.qoi.dof;
qt = canti.qoi.t;

Ki = canti.sti.mtxCell{1};
Ks = canti.sti.mtxCell{2};

pmi = 1;
pms = 1;

K = Ki * pmi + Ks * pms;

M = canti.mas.mtx;

pmc = 1;
C = pmc * Ki;

F = canti.fce.val;

phi = canti.phi.val;
phiz = eye(nd);

dT = canti.time.step;
maxT = canti.time.max;

U0 = zeros(nd, 1);
V0 = zeros(nd, 1);

%% exact solution.
[~, ~, ~, U, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiz, M, C, K, F, 'average', dT, maxT, U0, V0);

%% reduced solution.
m = phi' * M * phi;
c = phi' * C * phi;
k = phi' * K * phi;
f = phi' * F;
u0 = zeros(nr, 1);
v0 = zeros(nr, 1);

[alu, alv, ala, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dT, maxT, u0, u0);
Ur = phi * alu;
% overall error (no qoi) is normal and very small, thus problem is in qoi.
err = norm(U - Ur, 'fro') / norm(canti.dis.trial, 'fro');

Uq = U(qd, qt);
Urq = Ur(qd, qt);

errq = norm(Uq - Urq, 'fro') / norm(canti.dis.qoi.trial, 'fro');

%% residual based exact solution.
R = F - M * phi * ala - C * phi * alv - K * phi * alu;
[~, ~, ~, Uresi, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiz, M, C, K, R, 'average', dT, maxT, U0, V0);
errResi = norm(Uresi, 'fro') / norm(canti.dis.trial, 'fro');
errResiq = norm(Uresi(qd, qt), 'fro') / norm(canti.dis.qoi.trial, 'fro');