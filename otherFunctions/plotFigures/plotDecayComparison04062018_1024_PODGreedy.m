clear; clc;
plotData;
cd ~/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy;
%% 
% POD-Greedy vs Halton.
load('errPODGreedy.mat', 'errPODGreedy');
load('errHalton.mat', 'errHalton');
exp = [errPODGreedy.store.redInfo{2:end, 3}];
eyp = errPODGreedy.store.realMax;
exh = [errHalton.store.redInfo{2:end, 3}];
eyh = errHalton.store.realMax;
figure(1)
semilogy(exp, eyp, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(exh, eyh, 'r-*', 'lineWidth', lwOther);
xticks(exp);
axis([0 exh(end) eyp(end) eyp(1)]);
axis normal
grid on
legend({stStr, 'Quasi-random (Halton)'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll);
xlabel(strcat(xLab, ' (Standard)'), 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%%
% POD-Greedy vs Sobol.
load('errSobol.mat', 'errSobol');
exs = [errSobol.store.redInfo{2:end, 3}];
eys = errSobol.store.realMax;
figure(2)
semilogy(exp, eyp, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(exs, eys, 'c-*', 'lineWidth', lwOther);
xticks(exp);
axis([0 exh(end) eyp(end) eyp(1)]);
axis normal
grid on
legend({stStr, 'Quasi-random (Sobol)'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll);
xlabel(strcat(xLab, ' (Standard)'), 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%% 
% POD-Greedy vs random.
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
exr1 = [errRandom1.store.redInfo{2:end, 3}];
exr2 = [errRandom2.store.redInfo{2:end, 3}];
exr3 = [errRandom3.store.redInfo{2:end, 3}];
exr4 = [errRandom4.store.redInfo{2:end, 3}];
exr5 = [errRandom5.store.redInfo{2:end, 3}];
eyr1 = errRandom1.store.realMax;
eyr2 = errRandom2.store.realMax;
eyr3 = errRandom3.store.realMax;
eyr4 = errRandom4.store.realMax;
eyr5 = errRandom5.store.realMax;
figure(3)
semilogy(exp, eyp, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(exr1, eyr1, 'k-.', 'lineWidth', lwOther);
semilogy(exr2, eyr2, 'k-.', 'lineWidth', lwOther);
semilogy(exr3, eyr3, 'k-.', 'lineWidth', lwOther);
semilogy(exr4, eyr4, 'k-.', 'lineWidth', lwOther);
semilogy(exr5, eyr5, 'k-.', 'lineWidth', lwOther);
xticks(exp);
axis([0 exh(end) eyp(end) eyp(1)]);
axis normal
grid on
legend({stStr, 'Pseudorandom'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll);
xlabel(strcat(xLab, ' (Standard)'), 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);

%%
% POD-Greedy vs Latin.
load('errLatin1.mat', 'errLatin1')
load('errLatin2.mat', 'errLatin2')
load('errLatin3.mat', 'errLatin3')
load('errLatin4.mat', 'errLatin4')
load('errLatin5.mat', 'errLatin5')
exl1 = [errLatin1.store.redInfo{2:end, 3}];
exl2 = [errLatin2.store.redInfo{2:end, 3}];
exl3 = [errLatin3.store.redInfo{2:end, 3}];
exl4 = [errLatin4.store.redInfo{2:end, 3}];
exl5 = [errLatin5.store.redInfo{2:end, 3}];
eyl1 = errLatin1.store.realMax;
eyl2 = errLatin2.store.realMax;
eyl3 = errLatin3.store.realMax;
eyl4 = errLatin4.store.realMax;
eyl5 = errLatin5.store.realMax;
figure(4)
semilogy(exp, eyp, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
hold on
semilogy(exl1, eyl1, 'g--', 'lineWidth', lwOther);
semilogy(exl2, eyl2, 'g--', 'lineWidth', lwOther);
semilogy(exl3, eyl3, 'g--', 'lineWidth', lwOther);
semilogy(exl4, eyl4, 'g--', 'lineWidth', lwOther);
semilogy(exl5, eyl5, 'g--', 'lineWidth', lwOther);
xticks(exp);
axis([0 exh(end) eyp(end) eyp(1)]);
axis normal
grid on
legend({stStr, 'Latin hypercube'}, 'FontSize', fsAll);
set(gca,'fontsize', fsAll);
xlabel(strcat(xLab, ' (Standard)'), 'FontSize', fsAll);
ylabel(yLab, 'FontSize', fsAll);
