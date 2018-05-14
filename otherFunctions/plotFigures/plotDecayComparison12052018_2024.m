clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/12052018_2024+;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')

%% plot decay value curve.
errxOri = [4 6 8 10 13 14 18 20 24 34 39];
errOriMax = errOriginalStore.store.max;
errxPro = [4 7 8 10 12 14 22 26 30 33 38];
errProMax = errProposedStore.store.max.verify;

figure(1)
semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(errxPro, errProMax, 'r-^', 'MarkerSize', 10, 'lineWidth', 3);
axis normal 
grid on

xticks(errxOri);

ax1 = gca;
set(ax1, 'XAxisLocation', 'top');

xticks(errxPro);
ax2 = gca;

set(ax2, 'XAxisLocation', 'bottom');
