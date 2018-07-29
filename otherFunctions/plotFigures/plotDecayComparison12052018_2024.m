clear; clc; clf;
cd ~/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/;
plotData;
load('errOriginalStore80.mat', 'errOriginalStore80')
load('nouiTuj/errProposedNouiTujN30Redu=80.mat', ...
    'errProposedNouiTujN30')
load('errRandom1_60.mat', 'errRandom1')
load('errRandom2_60.mat', 'errRandom2')
load('errRandom3_60.mat', 'errRandom3')
load('errRandom4_60.mat', 'errRandom4')
load('errRandom5_60.mat', 'errRandom5')
errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax5 = errRandom5.store.max;

%% plot decay value curve.
clf; 
errxOri = [errOriginalStore80.store.redInfo{2:end, 3}];
errOriMax = errOriginalStore80.store.realMax;
errxPro = [errProposedNouiTujN30.store.redInfo{2:end, 3}];
errProMax = errProposedNouiTujN30.store.max.verify;
errRanx1 = [errRandom1.store.redInfo{2:end - 1, 3}];
errRanx2 = [errRandom2.store.redInfo{2:end - 1, 3}];
errRanx3 = [errRandom3.store.redInfo{2:end - 1, 3}];
errRanx4 = [errRandom4.store.redInfo{2:end - 1, 3}];
errRanx5 = [errRandom5.store.redInfo{2:end - 1, 3}];

figure(1)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
grid on
hold all
semilogy(errxPro, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);
ylim([errOriMax(end) errOriMax(1)])

legend({stStr, proStr}, 'FontSize', fsAll);
ax1 = gca;
ax1.XColor = 'b';
ax1.XTick = errxOri;
xlimr = 76;
ax1.XLim = [0 xlimr];
xlabel('Total number of basis vectors (standard)', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', fsAll);
set(gca,'fontsize', fsAll)
ax2 = axes(...
    'Position',       ax1.Position,...
    'XAxisLocation',  'top',...
    'Color',          'none',...
    'YTick',          [],...
    'XLim',           [0 xlimr],...
    'XTick',          errxPro);
ax2.XColor = 'r';
ax2.XTick = errxPro;
xlabel('Total number of basis vectors (proposed)', 'FontSize', 20);
set(gca,'fontsize', fsAll)
grid on
hold on

%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errOriginalStore80.store.realLoc);
errPmLocPro = pmSpacePro(errProposedNouiTujN30.store.loc.verify(:, 1));
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', msAll, 'LineWidth', lwAll)
hold on
loglog(errPmLocPro, errProMax, 'r-^', 'MarkerSize', msAll, 'LineWidth', lwAll)
axis([10^-1 10^1 0 errOriMax(1)])
grid on
legend({stStr, proStr}, 'FontSize', fsAll);
set(gca,'fontsize',fsAll)
xlabel('Young''s modulus', 'FontSize', fsAll);
ylabel('Maximum relative error', 'FontSize', fsAll);

% %% proposed vs pseudorandom.
% har1 = semilogy(errRanx1, errRanMax1, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
% har2 = semilogy(errRanx2, errRanMax2, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
% har3 = semilogy(errRanx3, errRanMax3, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
% har4 = semilogy(errRanx4, errRanMax4, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
% har5 = semilogy(errRanx5, errRanMax5, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);