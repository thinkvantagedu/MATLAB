%% trial = 1.
% clear; clc;

trial = 1;

drawRow = 1;
drawCol = 20;
nPhiInitial = 2;
nPhiEnrich = 2;
% % proposed.
% domLengi = 65;
% damLeng = 65;
% profile clear; profile off; profile on;
% callIbeamPODonRvDamping;
% errProposedNouiTujN20Iter20Add2 = canti.err;
% field = 'pre';
% errProposedNouiTujN20Iter20Add2 = rmfield(errProposedNouiTujN20Iter20Add2, field);
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1/errProposedNouiTujN20Iter20Add2.mat', ...
%     'errProposedNouiTujN20Iter20Add2', '-v7.3')
% errProposedNouiTujN20Iter20Add2Profiler = profile('info');
% save errProposedNouiTujN20Iter20Add2Profiler errProposedNouiTujN20Iter20Add2Profiler;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1/errProposedNouiTujN20Iter20Add2Profiler.mat', ...
%     'errProposedNouiTujN20Iter20Add2Profiler', '-v7.3')
% 
% original.
domLengi = 9;
damLeng = 9;
profile clear; profile off; profile on;
callIbeamOriginalDamping; 
errOriginalIter20Add2 = canti.err;
save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1/errOriginalIter20Add2.mat', ...
    'errOriginalIter20Add2', '-v7.3')
errOriginalIter20Add2Profiler = profile('info');
save errOriginalIter20Add2Profiler errOriginalIter20Add2Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1/errOriginalIter20Add2Profiler.mat', ...
    'errOriginalIter20Add2Profiler', '-v7.3')
disp('trial = 1 finish')

%% trial = 4225.
% clear; clc;
% trial = 4225;
% 
% drawRow = 1;
% drawCol = 20;
% nPhiInitial = 2;
% nPhiEnrich = 2;
% % proposed.
% domLengi = 65;
% damLeng = 65;
% profile clear; profile off; profile on;
% callIbeamPODonRvDamping;
% errProposedNouiTujN20Iter20Add2 = canti.err;
% field = 'pre';
% errProposedNouiTujN20Iter20Add2 = rmfield(errProposedNouiTujN20Iter20Add2, field);
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errProposedNouiTujN20Iter20Add2.mat', ...
%     'errProposedNouiTujN20Iter20Add2', '-v7.3')
% errProposedNouiTujN20Iter20Add2Profiler = profile('info');
% save errProposedNouiTujN20Iter20Add2Profiler errProposedNouiTujN20Iter20Add2Profiler;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errProposedNouiTujN20Iter20Add2Profiler.mat', ...
%     'errProposedNouiTujN20Iter20Add2Profiler', '-v7.3')
% 
% % original.
% trial = 81;
% domLengi = 9;
% damLeng = 9;
% profile clear; profile off; profile on;
% callIbeamOriginalDamping;
% errOriginalIter20Add2 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errOriginalIter20Add2.mat', ...
%     'errOriginalIter20Add2', '-v7.3')
% errOriginalIter20Add2Profiler = profile('info');
% save errOriginalIter20Add2Profiler errOriginalIter20Add2Profiler;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errOriginalIter20Add2Profiler.mat', ...
%     'errOriginalIter20Add2Profiler', '-v7.3')
% disp('trial = 1089 finish')
