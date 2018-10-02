cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errProposedNouiTujN20Iter20Add2.mat', ...
    'errProposedNouiTujN20Iter20Add2');
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
phiPro = errProposedNouiTujN20Iter20Add2.phi.val;
phiOri = errOriginalIter20Add2.phi.val;
% scalars.
nInit = 2;
nAdd = 2;
nIter = 20;
nRb = nAdd * nIter;
nPar = 9;
% systems.
K1 = canti.sti.mtxCell{1};
K2 = canti.sti.mtxCell{2};
M = canti.mas.mtx;
F = canti.fce.val;
dt = canti.time.step;
maxt = canti.time.max;
U0 = zeros(length(K1), 1);
V0 = zeros(length(K1), 1);
phiid = eye(length(K1));
qd = canti.qoi.dof;
qt = canti.qoi.t;
pm1 = logspace(-1, 1, nPar);
pm2 = logspace(-1, 1, nPar);

dis0norm = canti.dis.norm.trial;
errSurfStore = cell(nIter, 1); % store all surfs.
errMaxStore = zeros(nIter, 1); % store all max error.
% main.
for iIter = 1:nIter
    eSurf = zeros(nPar, nPar);
    nic = 2 * iIter;
    phiV = phiPro(:, 1:nic);
    for iPm = 1:nPar
        for jPm = 1:nPar
            pmPro = [pm1(iPm) pm2(jPm)];
            % exact solution.
            KPro = K1 * pmPro(1) + K2 * 1;
            CPro = K1 * pmPro(2);
            [Uexact, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phiid, M, CPro, KPro, F, 'average', dt, maxt, U0, V0);
            % approximation.
            mPro = phiV' * M * phiV;
            kPro = phiV' * KPro * phiV;
            cPro = phiV' * CPro * phiV;
            fPro = phiV' * F;
            u0 = zeros(length(kPro), 1);
            v0 = zeros(length(kPro), 1);
            [rvDis, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phiV, mPro, cPro, kPro, fPro, 'average', dt, maxt, u0, v0);
            Uappro = phiV * rvDis;
            Uerr = Uexact - Uappro;
            errPro = norm(Uerr(qd, qt), 'fro') / dis0norm;
            eSurf(iPm, jPm) = eSurf(iPm, jPm) + errPro;
        end
    end
    errSurfStore{iIter} = eSurf;
    em = max(eSurf(:));
    errMaxStore(iIter) = errMaxStore(iIter) + em;
    disp(iIter)
    disp(em)
end