clear; clc; clf;
cd ~/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=129/;
plotData;
load('errOriginalStore80.mat', 'errOriginalStore80')
load('~/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=129/nouiTuj/errProposedNouiTujN30Redu80.mat', ...
    'errProposedNouiTujN30Redu80')
load('~/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=129/nouiTuj/errProposedNouiTujN30InitRefRedu80.mat', ...
    'errProposedNouiTujN30InitRefRedu80')
load('errRandom1_80.mat', 'errRandom1_80')
load('errRandom2_80.mat', 'errRandom2_80')
load('errRandom3_80.mat', 'errRandom3_80')
load('errRandom4_80.mat', 'errRandom4_80')
load('errRandom5_80.mat', 'errRandom5_80')
load('errLatin1_80.mat', 'errLatin1_80')
load('errLatin2_80.mat', 'errLatin2_80')
load('errLatin3_80.mat', 'errLatin3_80')
load('errLatin4_80.mat', 'errLatin4_80')
load('errLatin5_80.mat', 'errLatin5_80')
load('errSobol80.mat', 'errSobol80')
load('errStruct80.mat', 'errStruct80')

%% plot decay value curve.
errxOri = [errOriginalStore80.store.redInfo{2:end, 3}];
errOriMax = errOriginalStore80.store.realMax;
errxPro = [errProposedNouiTujN30Redu80.store.redInfo{2:end, 3}];
errProMax = errProposedNouiTujN30Redu80.store.max.verify;
errxRef = [errProposedNouiTujN30InitRefRedu80.store.redInfo{2:end, 3}];
errProRef = errProposedNouiTujN30InitRefRedu80.store.max.verify;
ylimit = [errProRef(end) errProRef(1)];
figure(1)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold all
semilogy(errxPro, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errxRef, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
ylim(ylimit)

legend({stStr, proStr, proRefStr}, 'FontSize', fsAll);
ax1 = gca;
ax1.XColor = 'b';
ax1.XTick = errxOri;
xlimr = 85;
ax1.XLim = [0 xlimr];
xlabel('N (standard)', 'FontSize', 15);
ylabel('Maximum relative error', 'FontSize', fsAll);
set(gca,'fontsize', fsAll - 5)
ax2 = axes(...
    'Position',       ax1.Position,...
    'XAxisLocation',  'top',...
    'Color',          'none',...
    'YTick',          [],...
    'XLim',           [0 xlimr],...
    'XTick',          errxRef);
ax2.XColor = royalGreen;
ax2.XTick = errxRef;
xlabel(sprintf('N (proposed with  initial refinement)'), 'FontSize', 15);
set(gca,'fontsize', fsAll - 5)
grid on

%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errOriginalStore80.store.realLoc);
errPmLocPro = pmSpacePro(errProposedNouiTujN30Redu80.store.loc.verify(:, 1));
errPmLocRef = pmSpacePro(errProposedNouiTujN30InitRefRedu80.store.loc.verify(:, 1));
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll)
hold on
loglog(errPmLocPro, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll)
loglog(errPmLocPro, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll)
axis([10^-1 10^1 ylimit])
grid on
legend({stStr, proStr, proRefStr}, 'FontSize', fsAll);
set(gca,'fontsize',fsAll)
xlabel('Young''s modulus', 'FontSize', fsAll);
ylabel('Maximum relative error', 'FontSize', fsAll);

%% proposed vs pseudorandom.
errRanMax1 = errRandom1_80.store.realMax;
errRanMax2 = errRandom2_80.store.realMax;
errRanMax3 = errRandom3_80.store.realMax;
errRanMax4 = errRandom4_80.store.realMax;
errRanMax5 = errRandom5_80.store.realMax;
errRanx1 = [errRandom1_80.store.redInfo{2:end, 3}];
errRanx2 = [errRandom2_80.store.redInfo{2:end, 3}];
errRanx3 = [errRandom3_80.store.redInfo{2:end, 3}];
errRanx4 = [errRandom4_80.store.redInfo{2:end, 3}];
errRanx5 = [errRandom5_80.store.redInfo{2:end, 3}];
figure(3)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errxRef, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errRanx1, errRanMax1, 'k-.', 'lineWidth', lwOther);
semilogy(errRanx2, errRanMax2, 'k-.', 'lineWidth', lwOther);
semilogy(errRanx3, errRanMax3, 'k-.', 'lineWidth', lwOther);
semilogy(errRanx4, errRanMax4, 'k-.', 'lineWidth', lwOther);
semilogy(errRanx5, errRanMax5, 'k-.', 'lineWidth', lwOther);
axis([0 120 ylimit]);
axis normal
grid on
legend({stStr, proRefStr, 'Pseudorandom'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs Latin.
errLatinMax1 = errLatin1_80.store.realMax;
errLatinMax2 = errLatin2_80.store.realMax;
errLatinMax3 = errLatin3_80.store.realMax;
errLatinMax4 = errLatin4_80.store.realMax;
errLatinMax5 = errLatin5_80.store.realMax;
errLatinx1 = [errLatin1_80.store.redInfo{2:end, 3}];
errLatinx2 = [errLatin2_80.store.redInfo{2:end, 3}];
errLatinx3 = [errLatin3_80.store.redInfo{2:end, 3}];
errLatinx4 = [errLatin4_80.store.redInfo{2:end, 3}];
errLatinx5 = [errLatin5_80.store.redInfo{2:end, 3}];
figure(4)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errxRef, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errLatinx1, errLatinMax1, 'g--', 'lineWidth', lwOther);
semilogy(errLatinx2, errLatinMax2, 'g--', 'lineWidth', lwOther);
semilogy(errLatinx3, errLatinMax3, 'g--', 'lineWidth', lwOther);
semilogy(errLatinx4, errLatinMax4, 'g--', 'lineWidth', lwOther);
semilogy(errLatinx5, errLatinMax5, 'g--', 'lineWidth', lwOther);
axis([0 120 ylimit]);
axis normal
grid on
legend({stStr, proRefStr, 'Latin Hypercube'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs Sobol.
errSobolMax = errSobol80.store.realMax;
errSobolx = [errSobol80.store.redInfo{2:end, 3}];
figure(5)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errxRef, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errSobolx, errSobolMax, 'c-*', 'lineWidth', lwOther);

axis([0 120 ylimit]);
axis normal
grid on
legend({stStr, proRefStr, 'Quasi-random (Sobol)'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% proposed vs struct.
errStructMax = errStruct80.store.realMax;
errStructx = [errStruct80.store.redInfo{2:end, 3}];
figure(6)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errxRef, errProRef, 'color', royalGreen, 'Marker', 'v', ...
    'MarkerSize', msAll, 'lineWidth', lwAll);
semilogy(errStructx, errStructMax, 'm-+', 'lineWidth', lwOther);

axis([0 120 ylimit]);
axis normal
grid on
legend({stStr, proRefStr, 'Structure'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);