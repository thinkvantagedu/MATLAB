clc; clf;
plotData;
% this script plots figures of I beam 3146 nodes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter10Add2.mat', 'errOriginalIter10Add2')
load('nouiTuj/errProposedNouiTujN20Iter10Add2.mat', 'errProposedNouiTujN20Iter10Add2')

nInit = 2;
nAdd = 2;
nRb = 20;
errx = (nInit:nAdd:nRb);

% extract error values at proposed magic points.
% manually find location of ehhat in original.

% errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 9 1; 1 1; 1 1; 1 1; 1 1; 1 1]; 
% for trial = 1, with uiTuj.
errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 6 1; 5 1; 2 1; 2 1; 3 1; 4 1];
% for trial = 1, no uiTuj.

errOriLoc = errOriginalIter10Add2.store.realLoc;
errProMax = zeros(length(errProLoc) - 1, 1);
errOriMax = errOriginalIter10Add2.store.realMax;
phiPro = errProposedNouiTujN20Iter10Add2.phi.val;
phiOri = errOriginalIter10Add2.phi.val;

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
for ic = 1:10
    % knowing magic point.
    % calculate 1 reduced variable --> approximation --> error.
    nic = 2 * ic;
    
    % proposed.
    phivPro = phiPro(:, 1:nic);
    pmpro = [pm1(errProLoc(ic + 1, 1)) pm2(errProLoc(ic + 1, 2))];
    Kpro = K1 * pmpro(1) + K2 * 1;
    Cpro = K1 * pmpro(2);
    mpro = phivPro' * M * phivPro;
    kpro = phivPro' * Kpro * phivPro;
    cpro = phivPro' * Cpro * phivPro;
    fpro = phivPro' * F;
    u0 = zeros(length(kpro), 1);
    v0 = zeros(length(kpro), 1);
    [rvDisPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phivPro, mpro, cpro, kpro, fpro, 'average', dt, maxt, u0, v0);
    [Upro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiid, M, Cpro, Kpro, F, 'average', dt, maxt, U0, V0);
    
    UerrPro = Upro - phivPro * rvDisPro;
    errPro = norm(UerrPro(qd, qt), 'fro') / canti.dis.norm.trial;
    errProMax(ic) = errProMax(ic) + errPro;
    
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
