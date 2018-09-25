plotData;
% run after plotAllCasesDecayComparisonIbeam1978nodes.m.
% cd('/Users/kevin/Documents/MATLAB/thesisResults/13092018_2218_Ibeam/trial=1');
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
% load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
% load('errProposedNouiTujN20Iter20Add2.mat', ...
%     'errProposedNouiTujN20Iter20Add2');
% load('errRandom5.mat', 'errRandom5')
% load('errLatin4.mat', 'errLatin4')
% load('errSobol.mat', 'errSobol')
% load('errHalton.mat', 'errHalton')
% 
% errLa4 = errLatin4.store.realMax;
% errRan5 = errRandom5.store.realMax;
% errSobol = errSobol.store.realMax;
% errHalton = errHalton.store.realMax;

nPro = 2:2:24;
nRan = [2 4 12 10 14 14 16 34 32 32 34 42]';
nLat = [2 4 10 10 10 26 26 48 32 34 34 48]';
nSob = [2 4 12 10 12 20 26 38 34 34 34 42]';
nHal = [2 4 10 10 12 14 24 36 34 34 34 50]';

nTest = 100;
nl = length(nRan);
% nd = length(qd);
% nt = length(qt);
nd = 5934;
nt = 100;
suStoreRan = zeros(nTest, nl);
suStoreLat = zeros(nTest, nl);
suStoreSob = zeros(nTest, nl);
suStoreHal = zeros(nTest, nl);

for it = 1:nTest
    for jt = 1:nl
        
        phiPro = rand(nd, nPro(jt));
        alPro = rand(nPro(jt), nt);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
        % random
        phiRan = rand(nd, nRan(jt));
        alRan = rand(nRan(jt), nt);
        funcRan = @() phiRan * alRan;
        trRan = timeit(funcRan);
        suRan = trRan / trPro - 1;
        suStoreRan(it, jt) = suStoreRan(it, jt) + suRan;
        % Latin
        phiLat = rand(nd, nLat(jt));
        alLat = rand(nLat(jt), nt);
        funcLat = @() phiLat * alLat;
        trLat = timeit(funcLat);
        suLat = trLat / trPro - 1;
        suStoreLat(it, jt) = suStoreLat(it, jt) + suLat;
        % Sobol
        phiSob = rand(nd, nSob(jt));
        alSob = rand(nSob(jt), nt);
        funcSob = @() phiSob * alSob;
        trSob = timeit(funcSob);
        suSob = trSob / trPro - 1;
        suStoreSob(it, jt) = suStoreSob(it, jt) + suSob;
        % Halton
        phiHal = rand(nd, nHal(jt));
        alHal = rand(nHal(jt), nt);
        funcHal = @() phiHal * alHal;
        trHal = timeit(funcHal);
        suHal = trHal / trPro - 1;
        suStoreHal(it, jt) = suStoreHal(it, jt) + suHal;
        
    end
end

suStoreRanm = mean(suStoreRan);
suStoreLatm = mean(suStoreLat);
suStoreSobm = mean(suStoreSob);
suStoreHalm = mean(suStoreHal);

%%
x = 1:12;
plot(x, suStoreRanm, 'k-o', 'MarkerSize', msAll, 'LineWidth', lwOther);
hold on
plot(x, suStoreLatm, 'g-^', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(x, suStoreSobm, 'c-*', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(x, suStoreHalm, 'm-+', 'MarkerSize', msAll, 'LineWidth', lwOther);
grid on
set(gca, 'fontsize', fsAll)
xticks(x)
legend({'Pseudorandom', 'Latin hypercube', 'Quasi-random (Sobol)', ...
    'Quasi-random (Halton)'}, 'FontSize', fsAll, 'Location', 'northwest');
xlabel(xLab, 'FontSize', fsAll);
ylabel('', 'FontSize', fsAll);
axis square
xlim([0 13])