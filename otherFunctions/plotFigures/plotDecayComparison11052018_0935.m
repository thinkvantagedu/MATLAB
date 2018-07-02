clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=1/;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')
%%
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom6')

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;

%% plot decay value curve.
errx = (nPhiIni:nPhiAdd:nRb);
errOriMax = errOriginalStore.store.max;
errProMax = errProposedStore.store.max.verify;

errRanMax1 = errRandom1.store.max;
errRanMax2 = errRandom2.store.max;
errRanMax3 = errRandom3.store.max;
errRanMax4 = errRandom4.store.max;
errRanMax6 = errRandom6.store.max;

figure(1)
semilogy(errx, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
hold on
semilogy(errx, errProMax, 'r-^', 'MarkerSize', 10, 'lineWidth', 3);
semilogy(errx, errRanMax1, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax2, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax3, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax4, 'k-.', 'lineWidth', 1.5);
semilogy(errx, errRanMax6, 'k-.', 'lineWidth', 1.5);
xticks(errx);
axis([0 nRb 0 errOriMax(1)]);
axis normal
grid on
legend({'Classical', 'Proposed', 'Random'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Total number of basis vectors', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);

% %% plot eine development on value curve.
% eine = [0.0048194 0.0037142 0.0032078 0.0024127 0.0012452 0.0014238 ...
%     0.0017214 0.0014185 0.00099074 0.0013527 0.0011604]';
% semilogy(errx, eine, 'r-^', 'LineWidth', 1.5);

%% plot decay location curve.
figure(2)
pmSpaceOri = logspace(-1, 1, 129);
pmSpacePro = logspace(-1, 1, 129);
errPmLocOri = pmSpaceOri(errOriginalStore.store.loc);
errPmLocPro = pmSpacePro(errProposedStore.store.loc.verify(:, 1));
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
axis([10^-1 10^1 0 errOriMax(1)])
grid on
legend({'Classical', 'Proposed'}, 'FontSize', 20);
set(gca,'fontsize',20)
xlabel('Parametric Domain', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);