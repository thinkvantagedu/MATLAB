% this script tests callFixiePODonRvDamping.
% generate system.
nd = fixie.no.dof;
nt = fixie.no.t_step;
dt = fixie.time.step;
qd = fixie.qoi.dof;
qt = fixie.qoi.t;
mt = fixie.time.max;
U0 = zeros(nd, 1);
V0 = zeros(nd, 1);

phi = fixie.phi.val;
ntest = 4;
pmIter = fixie.pmVal.hhat(ntest, 2);
Cf = fixie.pmVal.hhat(ntest, 3);

Ki = fixie.sti.mtxCell{1};
Ks = fixie.sti.mtxCell{2};

M = fixie.mas.mtx;
C = Cf * pmIter * Ki;
K = Ki * pmIter + Ks * 1;

F = fixie.fce.val;

% generate impulses.
impMv = M * phi;
impCv = Ki * phi;
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

m = phi' * M * phi;
c = phi' * C * phi;
k = phi' * K * phi;
f = phi' * F;
u0 = zeros(1);
v0 = zeros(1);

[km, cm, am, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dt, mt, u0, v0);
usStore = cell(4, nt);
for it = 1:nt
    if it == 1
        usStore{1, it} = UM1;
        usStore{2, it} = UC1;
        usStore{3, it} = UKi1;
        usStore{4, it} = UKs1;
    else
        usz = zeros(nd, it - 2);
        usm = [usz UM2(:, 1:nt - it + 2)];
        usc = [usz UC2(:, 1:nt - it + 2)];
        uski = [usz UKi2(:, 1:nt - it + 2)];
        usks = [usz UKs2(:, 1:nt - it + 2)];
        
        usStore{1, it} = usm;
        usStore{2, it} = usc;
        usStore{3, it} = uski;
        usStore{4, it} = usks;
    end
end
usStore = usStore(:);

[~, ~, ~, Uf, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiI, M, C, K, F, 'average', dt, mt, U0, V0);

usStore = cellfun(@(v) -v, usStore, 'un', 0);

usStore = [{Uf}; usStore];
usStore = cellfun(@(u) u(qd, qt), usStore, 'un', 0);

rvCol = [am; cm; km; km];
rvCol = num2cell([1; rvCol(:)]);

pmCol = num2cell([1; repmat([1; Cf * pmIter; pmIter; 1], nt, 1)]);

ucell = cellfun(@(u, v, w) u * v * w, usStore, rvCol, pmCol, 'un', 0);



U = zeros(length(qd), length(qt));
for iu = 1:length(ucell)
    
    U = U + ucell{iu};
    
end

enm = norm(U, 'fro') / norm(fixie.dis.qoi.trial, 'fro');

uColcell = (cellfun(@(v) v(:), usStore, 'un', 0))';

uTu = (cell2mat(uColcell))' * cell2mat(uColcell);
[~, uTu] = upperTriangleIntoVector(triu(uTu));

c = [];
for i = 1:41
    c = [c; norm(uColcell{i}, 'fro')];
end
