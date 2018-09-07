clear; clc;
% this script plots the convergence of different training set size. 
cd ~/Desktop/Temp/thesisResults/05062018_1153_trainingSetSize;

load('e17.mat', 'e17')
load('e33.mat', 'e33')
load('e65.mat', 'e65')
load('e129.mat', 'e129')
load('e257.mat', 'e257')
load('e513.mat', 'e513')
load('e1025.mat', 'e1025')

ex = 1:20;
ey17 = e17.store.max;
ey33 = e33.store.max;
ey65 = e65.store.max;
ey129 = e129.store.max;
ey257 = e257.store.max;
ey513 = e513.store.max;
ey1025 = e1025.store.max;

figure(1)
semilogy(ex, ey17, 'lineWidth', 1.5)
hold on
semilogy(ex, ey33, 'lineWidth', 1.5)
semilogy(ex, ey65, 'lineWidth', 1.5)
semilogy(ex, ey129, 'lineWidth', 1.5)
semilogy(ex, ey257, 'lineWidth', 1.5)
semilogy(ex, ey513, 'lineWidth', 1.5)
semilogy(ex, ey1025, 'lineWidth', 1.5)

legend('17', '33', '65', '129', '257', '513', '1025')
grid on
xlabel('N');
ylabel('Maximum relative error');

set(gca,'fontsize',20)
