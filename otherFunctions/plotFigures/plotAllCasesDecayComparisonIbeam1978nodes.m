plotData;
% cd('/Users/kevin/Documents/MATLAB/thesisResults/13092018_2218_Ibeam/trial=1');
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
load('errProposedNouiTujN20Iter20Add2.mat', ...
    'errProposedNouiTujN20Iter20Add2');

nInit = 2;
nAdd = 2;
nIter = 18;
nRb = nAdd * nIter;
errx = (nInit:nAdd:nRb);

% for trial = 1, no uiTuj.
errProLoc = [1 1; 5 1; 1 1; 1 1; 1 1; 6 1; 5 1; 2 1; 2 1; 3 1; ...
    4 1; 4 1; 2 1; 4 1; 4 1; 5 1; 3 1; 3 1; 5 1];
% for trial = 4225, no uiTuj.
% errProLoc = [9 9; 1 1; 1 1; 5 1; 1 1; 2 1; 3 1; 2 1; 2 1; 4 1; ...
%     2 1; 4 1; 3 1; 5 1; 1 1; 4 1; 4 1; 4 1; 7 1];
errOriLoc = errOriginalIter20Add2.store.realLoc;

%%
errProMax = zeros(nIter, 1);
errOriMax = errOriginalIter20Add2.store.realMax(1:nIter);
phiPro = errProposedNouiTujN20Iter20Add2.phi.val;
phiOri = errOriginalIter20Add2.phi.val;
%%
K1 = canti.sti.mtxCell{1};
K2 = canti.sti.mtxCell{2};
M = canti.mas.mtx;
F = canti.fce.val;
dt = canti.time.step;
maxt = canti.time.max;
U0 = zeros(length(K1), 1);
V0 = U0;
phiid = eye(length(K1));
qd = canti.qoi.dof;
qt = canti.qoi.t;
pm1 = logspace(-1, 1, 9);
pm2 = pm1;

for ic = 1:nIter
    
    nic = 2 * ic;
    phivPro = phiPro(:, 1:nic);
    pmPro = [pm1(errProLoc(ic + 1, 1)) pm2(errProLoc(ic + 1, 2))];
    Kpro = K1 * pmPro(1) + K2 * 1;
    Cpro = K1 * pmPro(2);
    mPro = phivPro' * M * phivPro;
    kPro = phivPro' * Kpro * phivPro;
    cPro = phivPro' * Cpro * phivPro;
    fPro = phivPro' * F;
    u0 = zeros(length(kPro), 1);
    v0 = u0;
    [rvDisPro, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phivPro, mPro, cPro, kPro, fPro, 'average', dt, maxt, u0, v0);
    [Uexact, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiid, M, Cpro, Kpro, F, 'average', dt, maxt, U0, V0);
    UerrPro = Uexact - phivPro * rvDisPro;
    errPro = norm(UerrPro(qd, qt), 'fro') / canti.dis.norm.trial;
    errProMax(ic) = errProMax(ic) + errPro;
    disp(ic)
end


%%
errxO = 2:2:50;
nRbO = 50;
% random
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
errRan1 = errRandom1.store.realMax;
errRan2 = errRandom2.store.realMax;
errRan3 = errRandom3.store.realMax;
errRan4 = errRandom4.store.realMax;
errRan5 = errRandom5.store.realMax;
% latin
load('errLatin1.mat', 'errLatin1')
load('errLatin2.mat', 'errLatin2')
load('errLatin3.mat', 'errLatin3')
load('errLatin4.mat', 'errLatin4')
load('errLatin5.mat', 'errLatin5')
errLa1 = errLatin1.store.realMax;
errLa2 = errLatin2.store.realMax;
errLa3 = errLatin3.store.realMax;
errLa4 = errLatin4.store.realMax;
errLa5 = errLatin5.store.realMax;
% Sobol
load('errSobol.mat', 'errSobol');
errSobol = errSobol.store.realMax;
% Halton
load('errHalton.mat', 'errHalton');
errHalton = errHalton.store.realMax;
% random
figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll);
semilogy(errxO, errRan1, 'k', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errRan2, 'k', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errRan3, 'k', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errRan4, 'k', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errRan5, 'k', 'MarkerSize', msAll, 'LineWidth', lwOther);

xticks(errxO);
axis([0 nRbO -inf inf])
axis square
grid on
set(gca, 'fontsize', fsAxis)
legend({stStr, proStr, 'Pseudorandom'}, 'FontSize', fsAll);
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);
% Latin
figure(2)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll);
semilogy(errxO, errLa1, 'g', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errLa2, 'g', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errLa3, 'g', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errLa4, 'g', 'MarkerSize', msAll, 'LineWidth', lwOther);
semilogy(errxO, errLa5, 'g', 'MarkerSize', msAll, 'LineWidth', lwOther);

xticks(errxO);
axis([0 nRbO -inf inf])
axis square
grid on
set(gca, 'fontsize', fsAxis)
legend({stStr, proStr, 'Latin hypercube'}, 'FontSize', fsAll);
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);
% Sobol
figure(3)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll);
semilogy(errxO, errSobol, 'c-*', 'MarkerSize', msAll, 'LineWidth', lwOther);

xticks(errxO);
axis([0 nRbO -inf inf])
axis square
grid on
set(gca, 'fontsize', fsAxis)
legend({stStr, proStr, 'Quasi-random (Sobol)'}, 'FontSize', fsAll);
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);
% Halton
figure(4)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll);
semilogy(errxO, errHalton, 'm-+', 'MarkerSize', msAll, 'LineWidth', lwOther);

xticks(errxO);
axis([0 nRbO -inf inf])
axis square
grid on
set(gca, 'fontsize', fsAxis)
legend({stStr, proStr, 'Quasi-random (Halton)'}, 'FontSize', fsAll);
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

















