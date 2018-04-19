clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/18042018_1112;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom6.mat', 'errRandom6')


errOriMax = errOriginalStore.max;
errOriLoc = errOriginalStore.loc;
errProMax = errProposedStore.max.hhat;
errProLoc = errProposedStore.loc.hhat;

errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax6 = errRandom6.store.max;

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;
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

axis([0 nRb errOriMax(end) / 2 1])
axis normal
grid on
legend({'Classical POD-Greedy', 'Proposed POD-Greedy', 'Random POD-Greedy'}, ...
    'FontSize', 20)

xlabel('N', 'FontSize', 20)
ylabel('Maximum error', 'FontSize', 20)
