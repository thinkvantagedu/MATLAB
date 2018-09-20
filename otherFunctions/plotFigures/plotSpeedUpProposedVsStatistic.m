clf; clear; clc;
plotData;
cd ~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=1/;
load('errOriginalStore.mat', 'errOriginalStore')
load('~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=65/nouiTuj/errProposedNouiTujN35.mat', 'errProposedNouiTujN35')
load('~/Desktop/Temp/thesisResults/11052018_0935+fixRbInc/trial=65/nouiTuj/errProposedNouiTujN30InitRef.mat', 'errProposedNouiTujN30InitRef')
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