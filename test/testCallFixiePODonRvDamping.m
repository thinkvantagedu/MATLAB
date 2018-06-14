% this script tests callFixiePODonRvDamping.
% generate system.
nd = fixie.no.dof;
nt = fixie.no.t_step;
dt = fixie.time.step;
mt = fixie.time.max;
U0 = zeros(nd, 1);
V0 = zeros(nd, 1);

phi = fixie.phi.val;
ntest = 45;
pmIter = fixie.pmVal.comb.space(ntest, 4);
Cf = fixie.pmVal.comb.space(ntest, 5);

Ki = fixie.sti.mtxCell{1};
Ks = fixie.sti.mtxCell{2};

M = fixie.mas.mtx;
C = Cf * pmIter * Ki;
K = Ki * pmIter + Ks * 1;

F = fixie.fce.val;

% generate impulses.
impMv = M * phi;
impCv = C * phi;
impKiv = Ki * phi;
impKsv = Ks * phi;

impM1 = zeros(nd, nt);
impM1(:, 1) = impM1(:, 1) + impMv;
impM2 = zeros(nd, nt);
impM2(:, 2) = impM2(:, 2) + impMv;

impC1 = zeros(nd, nt);
impC1(:, 1) = impC1(:, 1) + impCv;
impC2 = zeros(nd, nt);
impC2(:, 2) = impC2(:, 2) + impCv;

impKi1 = zeros(nd, nt);
impKi1(:, 1) = impKi1(:, 1) + impKiv;
impKi2 = zeros(nd, nt);
impKi2(:, 2) = impKi2(:, 2) + impKiv;

impKs1 = zeros(nd, nt);
impKs1(:, 1) = impKs1(:, 1) + impKsv;
impKs2 = zeros(nd, nt);
impKs2(:, 2) = impKs2(:, 2) + impKsv;

% compute impulse responses.
phiI = eye(nd);
[~, ~, ~, UM1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impM1, 'average', dt, mt, U0, V0);
[~, ~, ~, UM2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impM2, 'average', dt, mt, U0, V0);
[~, ~, ~, UC1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impC1, 'average', dt, mt, U0, V0);
[~, ~, ~, UC2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impC2, 'average', dt, mt, U0, V0);
[~, ~, ~, UKi1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKi1, 'average', dt, mt, U0, V0);
[~, ~, ~, UKi2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKi2, 'average', dt, mt, U0, V0);
[~, ~, ~, UKs1, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKs1, 'average', dt, mt, U0, V0);
[~, ~, ~, UKs2, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, impKs2, 'average', dt, mt, U0, V0);
