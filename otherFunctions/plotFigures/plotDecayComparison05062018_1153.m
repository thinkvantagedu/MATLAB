clear; clc;
% this script plots the convergence of different training set size. 
cd ~/Desktop/Temp/thesisResults/05062018_1153_trainingSetSize;

load('err17.mat', 'err17')
load('err33.mat', 'err33')
load('err65.mat', 'err65')
load('err129.mat', 'err129')
load('err257.mat', 'err257')
load('err513.mat', 'err513')
load('err1025.mat', 'err1025')

ex = 1:20;
ey17 = err17.store.max;
ey33 = err33.store.max;
ey65 = err65.store.max;
ey129 = err129.store.max;
ey257 = err257.store.max;
ey513 = err513.store.max;
ey1025 = err1025.store.max;

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
