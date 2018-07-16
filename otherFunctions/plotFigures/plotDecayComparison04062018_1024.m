clear; clc;

cd ~/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy;
%% 
% POD-Greedy vs Halton.
load('errPODGreedy.mat', 'errPODGreedy');
load('errHalton.mat', 'errHalton');
exp = [errPODGreedy.store.redInfo{2:end, 3}];
eyp = errPODGreedy.store.realMax;
nh = 8;
exh = [errHalton.store.redInfo{2:nh + 1, 3}];
eyh = errHalton.store.realMax(1:nh);
figure(1)
semilogy(exp, eyp, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(exh, eyh, 'r-*', 'lineWidth', 1.5);
xticks(exp);
axis([0 exh(end) + 2 0 eyp(1)]);
axis normal
grid on
legend({'POD-Greedy', 'Halton'}, 'FontSize', 20);
set(gca,'fontsize',20);
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

%%
% POD-Greedy vs Sobol.
load('errSobol.mat', 'errSobol');
ns = 7;
exs = [errSobol.store.redInfo{2:ns + 1, 3}];
eys = errSobol.store.realMax(1:ns);
figure(2)
semilogy(exp, eyp, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(exs, eys, 'c-*', 'lineWidth', 1.5);
xticks(exp);
axis([0 exh(end) + 2 0 eyp(1)]);
axis normal
grid on
legend({'POD-Greedy', 'Sobol'}, 'FontSize', 20);
set(gca,'fontsize',20);
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

%% 
% POD-Greedy vs random.
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
nr1 = 8;
nr2 = 8;
nr3 = 9;
nr4 = 8;
nr5 = 8;
exr1 = [errRandom1.store.redInfo{2:nr1 + 1, 3}];
exr2 = [errRandom2.store.redInfo{2:nr2 + 1, 3}];
exr3 = [errRandom3.store.redInfo{2:nr3 + 1, 3}];
exr4 = [errRandom4.store.redInfo{2:nr4 + 1, 3}];
exr5 = [errRandom5.store.redInfo{2:nr5 + 1, 3}];
eyr1 = errRandom1.store.realMax(1:nr1);
eyr2 = errRandom2.store.realMax(1:nr2);
eyr3 = errRandom3.store.realMax(1:nr3);
eyr4 = errRandom4.store.realMax(1:nr4);
eyr5 = errRandom5.store.realMax(1:nr5);
figure(3)
semilogy(exp, eyp, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(exr1, eyr1, 'k-.', 'lineWidth', 1.5);
semilogy(exr2, eyr2, 'k-.', 'lineWidth', 1.5);
semilogy(exr3, eyr3, 'k-.', 'lineWidth', 1.5);
semilogy(exr4, eyr4, 'k-.', 'lineWidth', 1.5);
semilogy(exr5, eyr5, 'k-.', 'lineWidth', 1.5);
xticks(exp);
axis([0 exh(end) + 2 0 eyp(1)]);
axis normal
grid on
legend({'POD-Greedy', 'Pseudorandom'}, 'FontSize', 20);
set(gca,'fontsize',20);
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

%%
% POD-Greedy vs Latin.
load('errLatin1.mat', 'errLatin1')
load('errLatin2.mat', 'errLatin2')
load('errLatin3.mat', 'errLatin3')
load('errLatin4.mat', 'errLatin4')
load('errLatin5.mat', 'errLatin5')

nl1 = 7;
nl2 = 7;
nl3 = 9;
nl4 = 8;
nl5 = 7;
exl1 = [errLatin1.store.redInfo{2:nl1 + 1, 3}];
exl2 = [errLatin2.store.redInfo{2:nl2 + 1, 3}];
exl3 = [errLatin3.store.redInfo{2:nl3 + 1, 3}];
exl4 = [errLatin4.store.redInfo{2:nl4 + 1, 3}];
exl5 = [errLatin5.store.redInfo{2:nl5 + 1, 3}];
eyl1 = errLatin1.store.realMax(1:nl1);
eyl2 = errLatin2.store.realMax(1:nl2);
eyl3 = errLatin3.store.realMax(1:nl3);
eyl4 = errLatin4.store.realMax(1:nl4);
eyl5 = errLatin5.store.realMax(1:nl5);
figure(4)
semilogy(exp, eyp, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(exl1, eyl1, 'g--', 'lineWidth', 1.5);
semilogy(exl2, eyl2, 'g--', 'lineWidth', 1.5);
semilogy(exl3, eyl3, 'g--', 'lineWidth', 1.5);
semilogy(exl4, eyl4, 'g--', 'lineWidth', 1.5);
semilogy(exl5, eyl5, 'g--', 'lineWidth', 1.5);
xticks(exp);
axis([0 exh(end) + 2 0 eyp(1)]);
axis normal
grid on
legend({'POD-Greedy', 'Latin hypercube'}, 'FontSize', 20);
set(gca,'fontsize',20);
xlabel('N', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);
