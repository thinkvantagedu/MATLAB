% this script tests callFixiePODonRvDamping for samples 7, 6, 9, 3.
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

Ki = fixie.sti.mtxCell{1};
Ks = fixie.sti.mtxCell{2};

M = fixie.mas.mtx;

F = fixie.fce.val;

%% generate impulses. ----------> pass
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
%% compute uiTui. ----------> pass
uiTuiStore = cell(4, 2);
uiTuiStore(:, 1) = {7; 6; 9; 3};
uColStore = cell(4, 2);
uColStore(:, 1) = {7; 6; 9; 3};

pmS = 10 .^ [-1 0 0 -1];
cfS = 10 .^ [0 0 1 1];

for iTest = 1:4
    % uiTui for sample 7, 6, 9, 3. -------------------> uiTuiStore pass test.
    pm = pmS(iTest);
    cf = cfS(iTest);
    testCallFixiePODonRvDampinguiTui;
    uiTuiStore(iTest, 2) = {uiTui};
    uColStore(iTest, 2) = {uColcell};
end
%% compute uiTuj. ----------> pass
uiTujStore = cell(4, 4);
uiTujStore(:, 1) = {7; 6; 9; 3};

% compute every 2 combinations.
uColcell7 = cellfun(@(v) v(:), uColStore{1, 2}, 'un', 0);
uColcell6 = cellfun(@(v) v(:), uColStore{2, 2}, 'un', 0);
uColcell9 = cellfun(@(v) v(:), uColStore{3, 2}, 'un', 0);
uColcell3 = cellfun(@(v) v(:), uColStore{4, 2}, 'un', 0);

uiTuj76 = (cell2mat(uColcell7))' * cell2mat(uColcell6);
uiTuj79 = (cell2mat(uColcell7))' * cell2mat(uColcell9);
uiTuj73 = (cell2mat(uColcell7))' * cell2mat(uColcell3);
uiTuj69 = (cell2mat(uColcell6))' * cell2mat(uColcell9);
uiTuj63 = (cell2mat(uColcell6))' * cell2mat(uColcell3);
uiTuj93 = (cell2mat(uColcell9))' * cell2mat(uColcell3);

uiTujStore(1, 2:end) = {uiTuj76 uiTuj79 uiTuj73};
uiTujStore(2, 3:end) = {uiTuj69 uiTuj63};
uiTujStore(3, 4:end) = {uiTuj93}; % ----------------------> uiTujStore passed.

%% collect reduced variables and pm values and perform POD.
nRvSVD = 14;
rvpmStore = cell(1, nIter);
for iIter = 1:nIter
    pmIter = fixie.pmVal.comb.space(iIter, 4);
    cfIter = fixie.pmVal.comb.space(iIter, 5);
    k = phi' * (Ki * pmIter + Ks * 1) * phi;
    c = phi' * (cfIter * pmIter * Ki) * phi;
    [rvDis, rvVel, rvAcc, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi, m, c, k, f, 'average', dt, mt, u0, v0);
    rvCol = [rvAcc; rvVel; rvDis; rvDis];
    rvCol = [1; rvCol(:)];
    
    pmCol = [1; repmat([1; cfIter * pmIter; pmIter; 1], nt, 1)];
    rvpmCol = rvCol .* pmCol;
    rvpmStore(iIter) = {rvpmCol};
end

[rvLOri, rvSigOri, rvROri] = svd(cell2mat(rvpmStore), 0);
rvL = rvLOri(:, 1:nRvSVD);
rvR = rvROri(:, 1:nRvSVD);
rvSig = rvSigOri(1:nRvSVD, 1:nRvSVD);
rvL = rvL * rvSig;

%% project uiTui and uiTuj.
uiTuipStore = uiTuiStore;
uiTujpStore = uiTujStore;

for ip = 1:4
    uiTuipStore{ip, 2} = rvL' * uiTuipStore{ip, 2} * rvL;
end

for ip = 1:3
    for jp = ip:3
        uiTujpStore{ip, jp + 1} = rvL' * uiTujpStore{ip, jp + 1} * rvL;
    end
end

%% interpolate.
nTest = 11;
pmcfTest = fixie.pmExpo.comb.space(nTest, 4:5);
[gridx, gridy] = meshgrid([-1 0], [0 1]);
cf1d = lagrange(pmcfTest(1), {gridx(1) gridx(3)});
cf2d = lagrange(pmcfTest(2), {gridy(1) gridy(2)});

cf12 = cf1d * cf2d';
cfcf = cf12(:) * cf12(:)';
uTu_ = cell(4, 4);
for iu = 1:4
    for ju = iu:4
        if iu == ju
            uTu_{iu, ju} = cfcf(iu, ju) * uiTuipStore{4, 2};
        else
            uTu_{iu, ju} = cfcf(iu, ju) * uiTujpStore{iu, ju};
        end
    end
end

uTu = sum(cat(3,uTu_{:}),3);
uTu = (uTu + uTu') / 2;

ePreSqrt = rvR * uTu * rvR';
ePreMtx = sqrt(abs(ePreSqrt)) / norm(fixie.dis.qoi.trial, 'fro');
ePreDiag = diag(ePreMtx);
eOtpt = ePreDiag(nTest);

%% compare: interpolate responses directly.
% itpl in x-dir using cf1d: 7-3 and 6-9.
cf1d1Dup = num2cell(repmat(cf1d(1), [1 41]));
cf1d2Dup = num2cell(repmat(cf1d(2), [1 41]));
ux1itpl76 = cellfun(@(u, v, w, x) u * v + w * x, ...
    cf1d1Dup, uColStore{1, 2}, cf1d2Dup, uColStore{2, 2}, 'un', 0);
ux1itpl39 = cellfun(@(u, v, w, x) u * v + w * x, ...
    cf1d1Dup, uColStore{4, 2}, cf1d2Dup, uColStore{3, 2}, 'un', 0);

% itpl in y-dir using cf2d. ux2itpl is the interpolated result. 
cf2d1Dup = num2cell(repmat(cf2d(1), [1 41]));
cf2d2Dup = num2cell(repmat(cf2d(2), [1 41]));
ux2itpl = cellfun(@(u, v, w, x) u * v + w * x, ...
    cf2d1Dup, ux1itpl76, cf2d2Dup, ux1itpl39, 'un', 0);

% multiply with rv and pm.
pmComp = fixie.pmVal.comb.space(nTest, 4);
cfComp = fixie.pmVal.comb.space(nTest, 5);
k = phi' * (Ki * pmComp + Ks * 1) * phi;
c = phi' * (cfComp * pmComp * Ki) * phi;
[rvDis, rvVel, rvAcc, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dt, mt, u0, v0);
rvColComp = [rvAcc; rvVel; rvDis; rvDis];
rvColComp = num2cell([1; rvColComp(:)]);

pmColComp = num2cell([1; repmat([1; cfComp * pmComp; pmComp; 1], nt, 1)]);

uComp = cellfun(@(u, v, w) u * v * w, pmColComp', rvColComp', ux2itpl, 'un', 0);

uComp = sum(cat(3,uComp{:}),3);

enmComp = norm(uComp, 'fro') / norm(fixie.dis.qoi.trial, 'fro');

pm = pmComp;
cf = cfComp;
testCallFixiePODonRvDampinguiTui;
