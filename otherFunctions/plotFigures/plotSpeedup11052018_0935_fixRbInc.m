clf; clc;
plotData;
% cd ~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=65/;
cd /Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/trial=1/;
load('errOriginalStore.mat', 'errOriginalStore')
load('nouiTuj/errProposedNouiTuj.mat', 'errProposedNouiTuj')
load('nouiTuj/errProposedNouiTujN30InitRef.mat', ...
    'errProposedNouiTujN30Redu60InitRef')
load('errRandom1.mat', 'errRandom1')
load('errRandom2.mat', 'errRandom2')
load('errRandom3.mat', 'errRandom3')
load('errRandom4.mat', 'errRandom4')
load('errRandom5.mat', 'errRandom5')
load('errLatin1.mat', 'errLatin1')
load('errLatin2.mat', 'errLatin2')
load('errLatin3.mat', 'errLatin3')
load('errLatin4.mat', 'errLatin4')
load('errLatin5.mat', 'errLatin5')
load('errSobol.mat', 'errSobol')
load('errStruct.mat', 'errStruct')

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;

errx = (nPhiIni:nPhiAdd:nRb);
%% Sobol.
vecSob = [10 18 18 30 38 42 46 46 50 50 50];
nTest = 100;
nv = length(errx);
trProSt = zeros(nTest, nv);
trSobSt = zeros(nTest, nv);
for it = 1:nTest
    for iv = 1:nv
        phiPro = rand(1054, errx(iv));
        alPro = rand(errx(iv), 50);
        funcPro = @() phiPro * alPro;
        trPro = timeit(funcPro);
        trProSt(it, iv) = trProSt(it, iv) + trPro;
        
        phiSob = rand(1054, vecSob(iv));
        alSob = rand(vecSob(iv), 50);
        funcSob = @() phiSob * alSob;
        trSob = timeit(funcSob);
        trSobSt(it, iv) = trSobSt(it, iv) + trSob;
    end
end
trProSt = sum(trProSt, 1) / nTest;
trSobSt = sum(trSobSt, 1) / nTest;

trSobRa = trSobSt ./ trProSt;