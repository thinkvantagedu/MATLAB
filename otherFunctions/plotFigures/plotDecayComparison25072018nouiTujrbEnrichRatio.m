clear; clc;
cd ~/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=129/;
load('errOriginalStore60.mat', 'errOriginalStore')
load('errProposedStore60.mat', 'errProposedStore')
load('errProposedNouiTujN30.mat', 'errProposedNouiTujN30')
% load('errOriginalStore80.mat', 'errOriginalStore80')
% load('errProposedStore80.mat', 'errProposedStore80')
% load('errProposedNouiTuj80.mat', 'errProposedNouiTuj80')
%% plot decay value curve.
clf; 
errxOri = [errOriginalStore.store.redInfo{2:end, 3}];
errOriMax = errOriginalStore.store.max;
errxPro = [errProposedStore.store.redInfo{2:end, 3}];
errProMax = errProposedStore.store.max.verify;
errxNo = [errProposedNouiTujN30.store.redInfo{2:end, 3}];
errNoMax = errProposedNouiTujN30.store.max.verify;

figure(1)
ha1 = semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
grid on
hold all
ha2 = semilogy(errxPro, errProMax, 'r-+', 'MarkerSize', 10, 'lineWidth', 3);
ha3 = semilogy(errxNo, errNoMax, 'g-v', 'MarkerSize', 10, 'lineWidth', 3);
ylim([errOriMax(end) errOriMax(1)])
%%
% errxOri80 = [errOriginalStore80.store.redInfo{2:end, 3}];
% errOriMax80 = errOriginalStore80.store.realMax;
% errxPro80 = [errProposedStore80.store.redInfo{2:end, 3}];
% errProMax80 = errProposedStore80.store.max.verify;
% % errxNo80 = [errProposedNouiTuj80.store.redInfo{2:end, 3}];
% % errNoMax80 = errProposedNouiTuj80.store.max.verify;
% figure(2)
% ha1 = semilogy(errxOri80, errOriMax80, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
% grid on
% hold all
% ha2 = semilogy(errxPro80, errProMax80, 'r-+', 'MarkerSize', 10, 'lineWidth', 3);
% % ha3 = semilogy(errxNo80, errNoMax80, 'g-v', 'MarkerSize', 10, 'lineWidth', 3);
% ylim([errProMax80(end) / 1.3 errOriMax80(1)])














% trial = 1, redu = 60, no > pro > ori; redu = 80, ori > no > pro
% trial = 65, redu = 60, ori > no > pro; redu = 80, ori > pro, no is waiting.
% trial = 129, redu = 60, ori > no > pro; redu = 80, waiting.