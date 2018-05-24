clear; clc;
cd ~/Desktop/Temp/thesisResults/12052018_2024+;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax5 = errRandom5.store.max;

%% plot decay value curve.
clf; 
errxOri = [4 6 8 10 13 14 18 20 24 34 39];
errOriMax = errOriginalStore.store.max;
errxPro = [4 7 8 10 12 14 22 26 30 33 38];
errProMax = errProposedStore.store.max.verify;
errRanx1 = [4 6 7 10 11 12 14 16 17 22 30 32 33 36 39 43 46];
errRanx2 = [4 6 7 8 9 10 11 13 14 15 17 23 25 28 33 35 36 44 ...
    45 46 47 48 49 50 51 55];
errRanx3 = [4 6 7 9 10 12 14 15 23 24 25 29 33 35];
errRanx4 = [4 6 7 8 9 12 19 20 22 23 24 29 33 35 38 39 40];
errRanx5 = [4 6 7 8 11 12 13 14 15 16 17 18 19 20 21 22 24 25 27 28 29 30 34 ...
    35 39 40 41 42 43 44 45 46 47 53];

figure(1)
ha1 = semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
grid on
hold all
ha2 = semilogy(errxPro, errProMax, 'r-+', 'MarkerSize', 10, 'lineWidth', 3);
ylim([0.028 errProMax(1)])

har1 = semilogy(errRanx1, errRanMax1, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
har2 = semilogy(errRanx2, errRanMax2, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
har3 = semilogy(errRanx3, errRanMax3, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
har4 = semilogy(errRanx4, errRanMax4, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
har5 = semilogy(errRanx5, errRanMax5, 'k-.', 'MarkerSize', 10, 'lineWidth', 1.5);
legend({'Classical', 'Implemented', 'Random'}, 'FontSize', 20);

ax1 = gca;
ax1.XColor = 'b';
ax1.XTick = errxOri;
ax1.XLim = [0 60];
xlabel('Total number of basis vectors (classical)', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);
set(gca,'fontsize',20)
ax2 = axes(...
    'Position',       ax1.Position,...
    'XAxisLocation',  'top',...
    'Color',          'none',...
    'YTick',          [],...
    'XLim',           [0 60],...
    'XTick',          errxPro);
ax2.XColor = 'r';
ax2.XTick = errxPro;
set(gca,'fontsize',20)
xlabel('Total number of basis vectors (implemented)', 'FontSize', 20);
grid on
hold on



%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errOriginalStore.store.loc);
errPmLocPro = pmSpacePro(errProposedStore.store.loc.verify(:, 1));
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', 10, 'LineWidth', 3)
hold on
loglog(errPmLocPro, errProMax, 'r-+', 'MarkerSize', 10, 'LineWidth', 3)
axis([10^-1 10^1 0 errOriMax(1)])
grid on
legend({'Classical', 'Implemented'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Parametric Domain', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);