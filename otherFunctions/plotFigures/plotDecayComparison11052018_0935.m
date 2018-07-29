clf; clear; clc;
plotData;
cd ~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=1/;
load('errOriginalStore.mat', 'errOriginalStore')
load('nouiTuj/errProposedNouiTuj.mat', 'errProposedNouiTuj')
load('nouiTuj/errProposedNouiTujN30InitRef.mat', 'errProposedNouiTujN30Redu60InitRef')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
load('errLatin1.mat', 'errLatin1')
load('errLatin2.mat', 'errLatin2')
load('errLatin3.mat', 'errLatin3')
load('errLatin4.mat', 'errLatin4')
load('errLatin5.mat', 'errLatin5')
load('errSobol.mat', 'errSobol')
load('errStruct.mat', 'errStruct')

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;

%% plot decay value curve.
errx = (nPhiIni:nPhiAdd:nRb);
errOriMax = errOriginalStore.store.max;
errProMax = errProposedNouiTuj.store.max.verify;
errProMaxRef = errProposedNouiTujN30Redu60InitRef.store.max.verify;

figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errx, errProMaxRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);

xticks(errx);
axis([0 nRb errOriMax(end) errOriMax(1)]);
axis normal
grid on
legend({stStr, proStr, ...
    proRefStr}, 'FontSize', fsAll);
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errOriginalStore.store.loc);
errPmLocPro = pmSpacePro(errProposedNouiTuj.store.loc.verify(:, 1));
errPmLocProRef = pmSpacePro(errProposedNouiTujN30Redu60InitRef.store.loc.verify(:, 1));
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll)
hold on
loglog(errPmLocPro, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll)
loglog(errPmLocProRef, errProMaxRef, 'color', [70 148 73]/255, 'Marker', 'v', ...
    'MarkerSize', msAll, 'LineWidth', lwAll)
axis([10^-1 10^1 0 errOriMax(1)])
grid on
legend({stStr, proStr, proRefStr}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel('Parametric Domain', 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs pseudorandom.
errRanMax1 = errRandom1.store.realMax;
errRanMax2 = errRandom2.store.realMax;
errRanMax3 = errRandom3.store.realMax;
errRanMax4 = errRandom4.store.realMax;
errRanMax5 = errRandom5.store.realMax;
figure(3)
semilogy(errx, errProMaxRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errRanMax1, 'k-.', 'lineWidth', lwOther);
semilogy(errx, errRanMax2, 'k-.', 'lineWidth', lwOther);
semilogy(errx, errRanMax3, 'k-.', 'lineWidth', lwOther);
semilogy(errx, errRanMax4, 'k-.', 'lineWidth', lwOther);
semilogy(errx, errRanMax5, 'k-.', 'lineWidth', lwOther);
xticks(errx);
axis([0 nRb errOriMax(end) errOriMax(1)]);
axis normal
grid on
legend({proRefStr, 'Pseudorandom'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs Latin.
errLatinMax1 = errLatin1.store.realMax;
errLatinMax2 = errLatin2.store.realMax;
errLatinMax3 = errLatin3.store.realMax;
errLatinMax4 = errLatin4.store.realMax;
errLatinMax5 = errLatin5.store.realMax;
figure(4)
semilogy(errx, errProMaxRef, 'color', royalGreen, 'Marker', 'v', ...
     'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errLatinMax1, 'g--', 'lineWidth', lwOther);
semilogy(errx, errLatinMax2, 'g--', 'lineWidth', lwOther);
semilogy(errx, errLatinMax3, 'g--', 'lineWidth', lwOther);
semilogy(errx, errLatinMax4, 'g--', 'lineWidth', lwOther);
semilogy(errx, errLatinMax5, 'g--', 'lineWidth', lwOther);
xticks(errx);
axis([0 nRb errOriMax(end) errOriMax(1)]);
axis normal
grid on
legend({proRefStr, 'Latin Hypercube'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs Sobol.
errSobol = errSobol.store.realMax;
figure(5)
semilogy(errx, errProMaxRef, 'color', royalGreen, 'Marker', 'v', ...
      'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errSobol, 'c-*', 'lineWidth', lwOther);
xticks(errx);
axis([0 nRb errOriMax(end) errOriMax(1)]);
axis normal
grid on
legend({proRefStr, 'Quasi-random (Sobol)'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs structure.
errStruct = errStruct.store.realMax;
figure(6)
semilogy(errx, errProMaxRef, 'color', royalGreen, 'Marker', 'v', ...
      'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errStruct, 'm-+', 'lineWidth', lwOther);
xticks(errx);
axis([0 nRb errOriMax(end) errOriMax(1)]);
axis normal
grid on
legend({proRefStr, 'Structure'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);


