plotData;
% run after plotAllCasesDecayComparisonIbeam1978nodes.m.
% cd('/Users/kevin/Documents/MATLAB/thesisResults/13092018_2218_Ibeam/trial=1');
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
% load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
% load('errProposedNouiTujN20Iter20Add2Validation.mat', ...
%     'errProposedNouiTujN20Iter20Add2Validation');
% load('errRandom5.mat', 'errRandom5')
% load('errLatin4.mat', 'errLatin4')
% load('errSobol.mat', 'errSobol')
% load('errHalton.mat', 'errHalton')
% 
% errLa4 = errLatin4.store.realMax;
% errRan5 = errRandom5.store.realMax;
% errSobol = errSobol.store.realMax;
% errHalton = errHalton.store.realMax;

nPro = 2:2:32;
nProh = 2:2:24;
nRan = [2 4 4 10 14 14 14 22 22 34 34 38 42 44 44 42]';
nLat = [2 4 4 10 10 14 26 26 26 34 42 48 50 50 50 50]';
nSob = [2 4 10 10 12 20 20 32 32 36 36 42 42 42 42 42]';
nHal = [2 4 4 10 12 14 14 26 26 34 36 50]';

nTest = 100;
nl = length(nRan);
nh = length(nHal);
% nd = length(qd);
% nt = length(qt);
nd = 5934;
nt = 100;
suStoreRan = zeros(nTest, nl);
suStoreLat = zeros(nTest, nl);
suStoreSob = zeros(nTest, nl);
suStoreHal = zeros(nTest, nh);

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
        
    end
end
for it = 1:nTest
    for jt = 1:nh
        phiPro = rand(nd, nProh(jt));
        alPro = rand(nProh(jt), nt);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
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
x = 1:16;
xh = 1:12;
plot(x, suStoreRanm, 'k-o', 'MarkerSize', msAll, 'LineWidth', lwOther);
hold on
plot(x, suStoreLatm, 'g-^', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(x, suStoreSobm, 'c-*', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(xh, suStoreHalm, 'm-+', 'MarkerSize', msAll, 'LineWidth', lwOther);
grid on
set(gca, 'fontsize', fsAll)
xticks(x)
legend({'Pseudorandom', 'Latin hypercube', 'Quasi-random (Sobol)', ...
    'Quasi-random (Halton)'}, 'FontSize', fsAll, 'Location', 'southeast');
xlabel(xLab, 'FontSize', fsAll);
ylabel('', 'FontSize', fsAll);
axis square
xlim([0 17])