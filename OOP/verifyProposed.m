cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2')
load('errProposedNouiTujN20Iter20Add2.mat', 'errProposedNouiTujN20Iter20Add2')

nInit = 2;
nAdd = 2;
nIter = 20;
nRb = nAdd * nIter;
nPar = 9;
errx = (nInit:nAdd:nRb);

% extract error values at proposed magic points.
% manually find location of ehhat in original.
% for trial = 1, with uiTuj.
% errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 9 1; 1 1; 1 1; 1 1; 1 1; 1 1]; 
% for trial = 1, no uiTuj.
errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 6 1; 5 1; 2 1; 2 1; 3 1; 4 1; ...
    4 1; 2 1; 4 1; 4 1; 5 1; 3 1; 3 1; 5 1; 6 1; 5 1];
% for trial = 4225, no uiTuj.
% errProLoc = [9 9; 1 1; 1 1; 5 1; 1 1; 2 1; 3 1; 2 1; 2 1; 4 1; 2 1; ...
%     4 1; 3 1; 5 1; 1 1; 4 1; 4 1; 4 1; 7 1; 7 1; 7 1];

errOriLoc = errOriginalIter20Add2.store.realLoc;
errProMax = zeros(length(errProLoc) - 1, 1);
errOriMax = errOriginalIter20Add2.store.realMax;
phiPro = errProposedNouiTujN20Iter20Add2.phi.val;
phiOri = errOriginalIter20Add2.phi.val;

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
eAllSurf = cell(nIter, 1);
eMaxStore = zeros(nIter, 1);
for ic = 1:nIter
    
    nic = 2 * ic;
    % proposed.
    phivPro = phiPro(:, 1:nic);
    eSurf = zeros(nPar, nPar);
    for id = 1:nPar
        for jd = 1:nPar
            % exact
            pmPro = [pm1(id) pm2(jd)];
            KPro = K1 * pmPro(1) + K2 * 1;
            CPro = K1 * pmPro(2);
            u0 = zeros(length(kPro), 1);
            v0 = zeros(length(kPro), 1);
            [Uexact, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phiid, M, CPro, KPro, F, 'average', dt, maxt, U0, V0);
            % approximation.
            mPro = phivPro' * M * phivPro;
            kPro = phivPro' * KPro * phivPro;
            cPro = phivPro' * CPro * phivPro;
            fPro = phivPro' * F;
            [rvDisPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phivPro, mPro, cPro, kPro, fPro, 'average', dt, maxt, u0, v0);
            Uappro = phivPro * rvDisPro;
            Uerr = Uexact - Uappro;
            errPro = norm(Uerr(qd, qt), 'fro') / canti.dis.norm.trial;
            eSurf(id, jd) = eSurf(id, jd) + errPro;
        end
    end
    eAllSurf{ic} = eSurf;
    eMax = max(eSurf(:));
    eMaxStore(ic) = eMaxStore(ic) + eMax;
    
end



















