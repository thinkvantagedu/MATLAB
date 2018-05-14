clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/12052018_2024+;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')

nPhiIni = 10;
nPhiAdd = 4;
nRb = 50;

%% plot decay value curve.
errx = (nPhiIni:nPhiAdd:nRb);
errOriMax = errOriginalStore.max;
errProMax = errProposedStore.store.max.verify;