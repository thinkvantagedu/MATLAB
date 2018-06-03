clear; clc; clf;
cd ~/Desktop/Temp/thesisResults/27052018_1516_GreedyProcedure;

load('errGreedy.mat', 'errGreedy')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')

    
errx = 1:5;
errOriMax = errGreedy.store.max;
errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax5 = errRandom5.store.max;
figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on;

semilogy(errx, errRanMax1, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax2, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax3, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax4, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax5, 'k-.', 'lineWidth', 1.5);
set(gca, 'YScale', 'log')

xticks(errx);
axis([0 6 0.54862525344e-13 errOriMax(1)]);
axis normal
grid on
legend({'Greedy', 'Random'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errGreedy.store.loc);
loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', 10, 'LineWidth', 3)
axis([10^-1 10^1 0.54862525344e-13 errOriMax(1)])
grid on
legend({'Greedy'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Young''s modulus', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);