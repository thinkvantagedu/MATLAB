clear; clc; clf;
plotData;
% this script plots convergence curves of I beam 8295 nodes.
cd ~/Desktop/Temp/thesisResults/13082018_0949_Ibeam/8295nodes/trial=1;
load('errOriginal.mat', 'errOriginal')
load('errProposedNouiTujN20.mat', 'errProposedNouiTujN20')

nInit = 1;
nAdd = 1;
nRb = 20;
errx = (nInit:nAdd:nRb);
errOriMax = errOriginal.store.realMax;
errProMax = errProposedNouiTujN20.store.max.hhat;

figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);

xticks(errx);
axis([0 nRb -inf inf]);
axis normal
grid on
% legend({stStr, proStr, ...
%     proRefStr}, 'FontSize', fsAll);
set(gca,'fontsize',fsAll)
xlabel(xLab, 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);