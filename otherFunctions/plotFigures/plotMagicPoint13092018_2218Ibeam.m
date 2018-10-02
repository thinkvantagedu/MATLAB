% this script plots magic point locations for I beam.
clf;
plotData;
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;

load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
load('errProposedNouiTujN20Iter20Add2.mat', ...
    'errProposedNouiTujN20Iter20Add2');
load('errRandom5.mat', 'errRandom5')
load('errLatin4.mat', 'errLatin4')
load('errSobol.mat', 'errSobol')
load('errHalton.mat', 'errHalton')

pmOriAll = logspace(-1, 1, 9);
pmProAll = logspace(-1, 1, 65);

locOri = errOriginalIter20Add2.store.realLoc;
locPro = errProposedNouiTujN20Iter20Add2.store.loc.hhat;
locRan = errRandom5.store.magicLoc;
locLat = errLatin4.store.magicLoc;
locSob = errSobol.store.magicLoc;
locHal = errHalton.store.magicLoc;

pmOri = pmOriAll(locOri);
pmPro = pmProAll(locPro);
pmSob = pmOriAll(locSob);
pmHal = pmOriAll(locHal);
pmLat = pmOriAll(locLat);
pmRan = pmOriAll(locRan);

figure(1)
scatter(pmPro(1, 1), pmPro(1, 2), 300, 'filled', 'r')
hold on
scatter(pmOri(:, 1), pmOri(:, 2), 80, 'filled', 'b')
scatter(pmSob(:, 1), pmSob(:, 2), 160, 'c', 'x', 'LineWidth', 4)
legend('Proposed', 'Reference', 'Sobol')

axis([0.1 10 0.1 10])
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
set(gca,'fontsize', fsAll)
grid minor
xlabel('Young''s Modulus', 'FontSize', fsAll);
ylabel('Damping Coefficient', 'FontSize', fsAll);
axis square

% figure(2)
% scatter(pmPro(:, 1), pmPro(:, 2), 80, 'filled', 'r')
% hold on
% scatter(pmOri(:, 1), pmOri(:, 2), 80, 'filled', 'b')
% scatter(pmHal(:, 1), pmHal(:, 2), 160, 'm', 'x', 'LineWidth', 4)
% legend('Proposed', 'Reference', 'Halton')
% 
% axis([0.1 10 0.1 10])
% set(gca, 'xscale', 'log')
% set(gca, 'yscale', 'log')
% set(gca,'fontsize', fsAll)
% grid minor
% xlabel('Young''s Modulus', 'FontSize', fsAll);
% ylabel('Damping Coefficient', 'FontSize', fsAll);
% axis square
% 
% figure(3)
% scatter(pmPro(:, 1), pmPro(:, 2), 80, 'filled', 'r')
% hold on
% scatter(pmOri(:, 1), pmOri(:, 2), 80, 'filled', 'b')
% scatter(pmLat(:, 1), pmLat(:, 2), 160, 'g', 'x', 'LineWidth', 4)
% legend('Proposed', 'Reference', 'Latin hypercube')
% 
% axis([0.1 10 0.1 10])
% set(gca, 'xscale', 'log')
% set(gca, 'yscale', 'log')
% set(gca,'fontsize', fsAll)
% grid minor
% xlabel('Young''s Modulus', 'FontSize', fsAll);
% ylabel('Damping Coefficient', 'FontSize', fsAll);
% axis square
% 
% figure(4)
% scatter(pmPro(:, 1), pmPro(:, 2), 80, 'filled', 'r')
% hold on
% scatter(pmOri(:, 1), pmOri(:, 2), 80, 'filled', 'b')
% scatter(pmRan(:, 1), pmRan(:, 2), 160, 'k', 'x', 'LineWidth', 4)
% legend('Proposed', 'Reference', 'Random')
% 
% axis([0.1 10 0.1 10])
% set(gca, 'xscale', 'log')
% set(gca, 'yscale', 'log')
% set(gca,'fontsize', fsAll)
% grid minor
% xlabel('Young''s Modulus', 'FontSize', fsAll);
% ylabel('Damping Coefficient', 'FontSize', fsAll);
% axis square