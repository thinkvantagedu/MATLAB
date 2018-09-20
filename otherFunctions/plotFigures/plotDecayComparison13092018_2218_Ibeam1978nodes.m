clc; clf;
plotData;
% this script plots figures of I beam 3146 nodes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2')
load('errProposedNouiTujN20Iter20Add2.mat', 'errProposedNouiTujN20Iter20Add2')

nInit = 2;
nAdd = 2;
nIter = 20;
nRb = nAdd * nIter;
errx = (nInit:nAdd:nRb);

% extract error values at proposed magic points.
% manually find location of ehhat in original.
% for trial = 1, with uiTuj.
% errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 9 1; 1 1; 1 1; 1 1; 1 1; 1 1]; 
% for trial = 1, no uiTuj.
errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 6 1; 5 1; 2 1; 2 1; 3 1; 4 1; ...
    4 1; 2 1; 4 1; 4 1; 5 1; 3 1; 3 1; 5 1; 6 1; 5 1];
% for trial = 4225, no uiTuj.
% errProLoc = [9 9; 1 1; 1 1; 5 1; 1 1; 2 1; 3 1; 2 1; 2 1; 4 1; 2 1];

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
pm1 = logspace(-1, 1, 9);
pm2 = logspace(-1, 1, 9);

errOriMax = zeros(nIter, 1);
for ic = 1:nIter
    % knowing magic point.
    % calculate 1 reduced variable --> approximation --> error.
    nic = 2 * ic;
    
    % proposed.
    phivPro = phiPro(:, 1:nic);
    pmPro = [pm1(errProLoc(ic + 1, 1)) pm2(errProLoc(ic + 1, 2))];
    KPro = K1 * pmPro(1) + K2 * 1;
    CPro = K1 * pmPro(2);
    mPro = phivPro' * M * phivPro;
    kPro = phivPro' * KPro * phivPro;
    cPro = phivPro' * CPro * phivPro;
    fPro = phivPro' * F;
    u0 = zeros(length(kPro), 1);
    v0 = zeros(length(kPro), 1);
    [rvDisPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phivPro, mPro, cPro, kPro, fPro, 'average', dt, maxt, u0, v0);
    [UPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiid, M, CPro, KPro, F, 'average', dt, maxt, U0, V0);
    
    UerrPro = UPro - phivPro * rvDisPro;
    errPro = norm(UerrPro(qd, qt), 'fro') / canti.dis.norm.trial;
    errProMax(ic) = errProMax(ic) + errPro;
    
    % original.
    phivOri = phiOri(:, 1:nic);
    pmOri = [pm1(errOriLoc(ic + 1, 1)) pm2(errOriLoc(ic + 1, 2))];
    KOri = K1 * pmOri(1) + K2 * 1;
    COri = K1 * pmOri(2);
    mOri = phivOri' * M * phivOri;
    kOri = phivOri' * KOri * phivOri;
    cOri = phivOri' * COri * phivOri;
    fOri = phivOri' * F;
    u0 = zeros(length(kOri), 1);
    v0 = zeros(length(kOri), 1);
    [rvDisOri, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phivOri, mOri, cOri, kOri, fOri, 'average', dt, maxt, u0, v0);
    [UOri, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiid, M, COri, KOri, F, 'average', dt, maxt, U0, V0);
    
    UerrOri = UOri - phivOri * rvDisOri;
    errOri = norm(UerrOri(qd, qt), 'fro') / canti.dis.norm.trial;
    errOriMax(ic) = errOriMax(ic) + errOri;
    
    disp(ic)
end

figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);

xticks(errx);
axis([0 nRb -inf inf]);
axis square
grid on
legend({stStr, proStr}, 'FontSize', fsAll);
set(gca,'fontsize', 20)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);
