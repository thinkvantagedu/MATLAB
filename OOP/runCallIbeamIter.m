%% trial = 1.
clear; clc;
trial = 1;

drawRow = 1;
drawCol = 20;
nPhiInitial = 3;
nPhiEnrich = 3;
% proposed.
domLengi = 33;
damLeng = 33;
profile clear; profile off; profile on;
callIbeamPODonRvDamping;
errProposedNouiTujIter20Add4 = canti.err;
field = 'pre';
errProposedNouiTujIter20Add4 = rmfield(errProposedNouiTujIter20Add4, field);
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/errProposedNouiTujIter20Add4.mat', ...
    'errProposedNouiTujIter20Add4', '-v7.3')
errProposedNouiTujIter20Add4Profiler = profile('info');
save errProposedNouiTujIter20Profiler errProposedNouiTujIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/errProposedNouiTujIter20Add4Profiler.mat', ...
    'errProposedNouiTujIter20Add4Profiler', '-v7.3')

% original.
domLengi = 9;
damLeng = 9;
profile clear; profile off; profile on;
callIbeamOriginalDamping; 
errOriginalIter20Add4 = canti.err;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/errOriginalIter20Add4.mat', ...
    'errOriginalIter20Add4', '-v7.3')
errOriginalIter20Add4Profiler = profile('info');
save errOriginalIter20Profiler errOriginalIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/errOriginalIter20Add4Profiler.mat', ...
    'errOriginalIter20Add4Profiler', '-v7.3')
disp('trial = 1 finish')

%% trial = 1089.
clear; clc;
trial = 1089;

drawRow = 1;
drawCol = 20;
nPhiInitial = 3;
nPhiEnrich = 3;
% proposed.
domLengi = 33;
damLeng = 33;
profile clear; profile off; profile on;
callIbeamPODonRvDamping;
errProposedNouiTujIter20Add4 = canti.err;
field = 'pre';
errProposedNouiTujIter20Add4 = rmfield(errProposedNouiTujIter20Add4, field);
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1089/errProposedNouiTujIter20Add4.mat', ...
    'errProposedNouiTujIter20Add4', '-v7.3')
errProposedNouiTujIter20Add4Profiler = profile('info');
save errProposedNouiTujIter20Profiler errProposedNouiTujIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1089/errProposedNouiTujIter20Add4Profiler.mat', ...
    'errProposedNouiTujIter20Add4Profiler', '-v7.3')

% original.
trial = 81;
domLengi = 9;
damLeng = 9;
profile clear; profile off; profile on;
callIbeamOriginalDamping;
errOriginalIter20Add4 = canti.err;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1089/errOriginalIter20Add4.mat', ...
    'errOriginalIter20Add4', '-v7.3')
errOriginalIter20Add4Profiler = profile('info');
save errOriginalIter20Profiler errOriginalIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1089/errOriginalIter20Add4Profiler.mat', ...
    'errOriginalIter20Add4Profiler', '-v7.3')
disp('trial = 1089 finish')
%% trial = 33.
clear; clc;
trial = 33;

drawRow = 1;
drawCol = 20;
nPhiInitial = 3;
nPhiEnrich = 3;
% proposed.
domLengi = 33;
damLeng = 33;
profile clear; profile off; profile on;
callIbeamPODonRvDamping;
errProposedNouiTujIter20Add4 = canti.err;
field = 'pre';
errProposedNouiTujIter20Add4 = rmfield(errProposedNouiTujIter10Add4, field);
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=33/errProposedNouiTujIter20Add4.mat', ...
    'errProposedNouiTujIter20Add4', '-v7.3')
errProposedNouiTujIter20Add4Profiler = profile('info');
save errProposedNouiTujIter20Profiler errProposedNouiTujIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=33/errProposedNouiTujIter20Add4Profiler.mat', ...
    'errProposedNouiTujIter20Add4Profiler', '-v7.3')

% original.
trial = 9;
domLengi = 9;
damLeng = 9;
profile clear; profile off; profile on;
callIbeamOriginalDamping;
errOriginalIter20Add4 = canti.err;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=33/errOriginalIter20Add4.mat', ...
    'errOriginalIter20Add4', '-v7.3')
errOriginalIter20Add4Profiler = profile('info');
save errOriginalIter20Profiler errOriginalIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=33/errOriginalIter20Add4Profiler.mat', ...
    'errOriginalIter20Add4Profiler', '-v7.3')
disp('trial = 33 finish')

%% trial = 1057.
clear; clc;
trial = 1057;

drawRow = 1;
drawCol = 20;
nPhiInitial = 3;
nPhiEnrich = 3;
% proposed.
domLengi = 33;
damLeng = 33;
profile clear; profile off; profile on;
callIbeamPODonRvDamping;
errProposedNouiTujIter20Add4 = canti.err;
field = 'pre';
errProposedNouiTujIter20Add4 = rmfield(errProposedNouiTujIter10Add4, field);
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1057/errProposedNouiTujIter20Add4.mat', ...
    'errProposedNouiTujIter20Add4', '-v7.3')
errProposedNouiTujIter20Add4Profiler = profile('info');
save errProposedNouiTujIter20Profiler errProposedNouiTujIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1057/errProposedNouiTujIter20Add4Profiler.mat', ...
    'errProposedNouiTujIter20Add4Profiler', '-v7.3')

% original.
trial = 73;
domLengi = 9;
damLeng = 9;
profile clear; profile off; profile on;
callIbeamOriginalDamping;
errOriginalIter20Add4 = canti.err;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1057/errOriginalIter20Add4.mat', ...
    'errOriginalIter20Add4', '-v7.3')
errOriginalIter20Add4Profiler = profile('info');
save errOriginalIter20Profiler errOriginalIter20Add4Profiler;
save('/home/xiaohan/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1057/errOriginalIter20Add4Profiler.mat', ...
    'errOriginalIter20Add4Profiler', '-v7.3')
disp('trial = 1057 finish')