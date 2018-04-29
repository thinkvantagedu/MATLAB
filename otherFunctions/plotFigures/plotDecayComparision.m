clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/18042018_1112+;
% cd ~/Desktop/Temp/thesisResults/26042018_1658;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom6.mat', 'errRandom6')

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;

%% plot decay value curve.
errOriMax = errOriginalStore.max;
errProMax = errProposedStore.max.hhat;

errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax6 = errRandom6.store.max;

figure(1)
semilogy((nPhiIni:nPhiAdd:nRb), errOriMax, ...
    'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy((nPhiIni:nPhiAdd:nRb), errProMax, ...
    'r-+', 'MarkerSize', 10, 'lineWidth', 3);
semilogy((nPhiIni:nPhiAdd:nRb), errRanMax1, 'k-.', 'lineWidth', 1.5);
semilogy((nPhiIni:nPhiAdd:nRb), errRanMax2, 'k-.', 'lineWidth', 1.5);
semilogy((nPhiIni:nPhiAdd:nRb), errRanMax3, 'k-.', 'lineWidth', 1.5);
semilogy((nPhiIni:nPhiAdd:nRb), errRanMax4, 'k-.', 'lineWidth', 1.5);
semilogy((nPhiIni:nPhiAdd:nRb), errRanMax6, 'k-.', 'lineWidth', 1.5);

axis([0 nRb errOriMax(end) / 2 1]);
axis normal
grid on
legend({'Classical POD-Greedy', 'Implemented POD-Greedy', 'Random POD-Greedy'}, ...
    'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Total number of basis vectors', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 1025);
errPmLocOri = pmSpaceOri(errOriginalStore.loc);
errPmLocPro = pmSpacePro(errProposedStore.loc.hhat);
% errPmLocRan1 = pmSpaceOri(errRandom1.store.loc);
% errPmLocRan2 = pmSpaceOri(errRandom2.store.loc);
% errPmLocRan3 = pmSpaceOri(errRandom3.store.loc);
% errPmLocRan4 = pmSpaceOri(errRandom4.store.loc);
% errPmLocRan6 = pmSpaceOri(errRandom6.store.loc);
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', 10, 'LineWidth', 3)
hold on
loglog(errPmLocPro, errProMax, 'r-+', 'MarkerSize', 10, 'LineWidth', 3)

% loglog(errPmLocRan1, errRanMax1, 'k-.', 'MarkerSize', 10, 'LineWidth', 1.5)
% loglog(errPmLocRan2, errRanMax2, 'k-.', 'MarkerSize', 10, 'LineWidth', 1.5)
% loglog(errPmLocRan3, errRanMax3, 'k-.', 'MarkerSize', 10, 'LineWidth', 1.5)
% loglog(errPmLocRan4, errRanMax4, 'k-.', 'MarkerSize', 10, 'LineWidth', 1.5)
% loglog(errPmLocRan6, errRanMax6, 'k-.', 'MarkerSize', 10, 'LineWidth', 1.5)

grid on
legend({'Classical POD-Greedy', 'Implemented POD-Greedy', 'Random POD-Greedy'}, ...
    'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Parametric Domain', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);