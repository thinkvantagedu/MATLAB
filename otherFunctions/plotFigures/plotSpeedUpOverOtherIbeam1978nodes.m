clf
plotData;
% run after plotAllCasesDecayComparisonIbeam1978nodes.m.
% cd('/Users/kevin/Documents/MATLAB/thesisResults/13092018_2218_Ibeam/trial=1');
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2');
load('errProposedNouiTujN20Iter20Add2PhiValid.mat', ...
    'errProposedNouiTujN20Iter20Add2PhiValid');
load('errRandom5.mat', 'errRandom5')
load('errLatin4.mat', 'errLatin4')
load('errSobol.mat', 'errSobol')
load('errHalton.mat', 'errHalton')

errLa4 = errLatin4.store.realMax;
errRan5 = errRandom5.store.realMax;
errSobol = errSobol.store.realMax;
errHalton = errHalton.store.realMax;

xPro = 2:2:30;
xLat = xPro;
xRan = 2:2:28;
xSob = xRan;
xHal = 2:2:24;
nRan = [2 4 4 10 14 14 16 28 32 32 32 34 42 42]';
nLat = [2 4 4 10 10 14 26 26 32 34 34 48 50 50 50]';
nSob = [2 4 10 10 12 20 20 34 34 34 34 42 42 42]';
nHal = [2 4 10 10 12 14 14 26 34 34 34 50]';

nTest = 20;
nr = length(nRan);
nh = length(nHal);
nl = length(nLat);
ns = length(nSob);
% nd = length(qd);
% nt = length(qt);
nd = 5934;
nt = 100;
suStoreRan = zeros(nTest, nr);
suStoreLat = zeros(nTest, nl);
suStoreSob = zeros(nTest, ns);
suStoreHal = zeros(nTest, nh);

for it = 1:nTest
    for jt = 1:nr
        
        phiPro = rand(nd, xPro(jt));
        alPro = rand(xPro(jt), nt);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
        % random
        phiRan = rand(nd, nRan(jt));
        alRan = rand(nRan(jt), nt);
        funcRan = @() phiRan * alRan;
        trRan = timeit(funcRan);
        suRan = trRan / trPro - 1;
        suStoreRan(it, jt) = suStoreRan(it, jt) + suRan;
        
    end
    
    for jt = 1:nh
        
        phiPro = rand(nd, xPro(jt));
        alPro = rand(xPro(jt), nt);
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
    
    for jt = 1:ns
        
        phiPro = rand(nd, xPro(jt));
        alPro = rand(xPro(jt), nt);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
        % Sobol
        phiSob = rand(nd, nSob(jt));
        alSob = rand(nSob(jt), nt);
        funcSob = @() phiSob * alSob;
        trSob = timeit(funcSob);
        suSob = trSob / trPro - 1;
        suStoreSob(it, jt) = suStoreSob(it, jt) + suSob;
        
    end
    
    for jt = 1:nl
        
        phiPro = rand(nd, xPro(jt));
        alPro = rand(xPro(jt), nt);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
        % Latin
        phiLat = rand(nd, nLat(jt));
        alLat = rand(nLat(jt), nt);
        funcLat = @() phiLat * alLat;
        trLat = timeit(funcLat);
        suLat = trLat / trPro - 1;
        suStoreLat(it, jt) = suStoreLat(it, jt) + suLat;
    end
end


suStoreRanm = mean(suStoreRan);
suStoreLatm = mean(suStoreLat);
suStoreSobm = mean(suStoreSob);
suStoreHalm = mean(suStoreHal);

%%
xr = 1:14;
xh = 1:12;
xl = 1:15;
xs = 1:14;
plot(xr, suStoreRanm, 'k-o', 'MarkerSize', msAll, 'LineWidth', lwOther);
hold on
plot(xl, suStoreLatm, 'g-^', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(xs, suStoreSobm, 'c-*', 'MarkerSize', msAll, 'LineWidth', lwOther);
plot(xh, suStoreHalm, 'm-+', 'MarkerSize', msAll, 'LineWidth', lwOther);
grid on
set(gca, 'fontsize', fsAll)
xticks(xl)
legend({'Pseudorandom', 'Latin hypercube', 'Quasi-random (Sobol)', ...
    'Quasi-random (Halton)'}, 'FontSize', fsAll, 'Location', 'southeast');
xlabel(xLab, 'FontSize', fsAll);
ylabel('Speed-up', 'FontSize', fsAll);
axis square
xlim([0 17])