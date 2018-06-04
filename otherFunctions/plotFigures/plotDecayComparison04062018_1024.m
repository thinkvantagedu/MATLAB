clear; clc;

cd ~/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy;
load('errPODGreedy.mat', 'errPODGreedy')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
nRb = 10;
exP = [3 4 6 7 8 10];
eyP = errPODGreedy.store.max;
exR = (3:10);
eyR1 = errRandom1.store.max;
eyR2 = errRandom2.store.max;
eyR3 = errRandom3.store.max;
eyR4 = errRandom4.store.max;
eyR5 = errRandom5.store.max;
%% error decay curve.
figure(1)
semilogy(exP, eyP, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(exR, eyR1, 'k-.', 'lineWidth', 1.5);
semilogy(exR, eyR2, 'k-.', 'lineWidth', 1.5);
semilogy(exR, eyR3, 'k-.', 'lineWidth', 1.5);
semilogy(exR, eyR4, 'k-.', 'lineWidth', 1.5);
semilogy(exR, eyR5, 'k-.', 'lineWidth', 1.5);
xticks(exP);
axis([0 nRb + 2 0 eyP(1)]);
axis normal
grid on
legend({'Classical', 'Random'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);
%% error location.
openfig('errDecayLoc.fig', 'new')
% view(2) % E-b: Young-damp
view([0 -90 0]) % E-e: Young-error
% view([90 0 0]) % b-e: damp-error