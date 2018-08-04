% callFixieOriginal;
% errLatin1_80 = fixie.err;    
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/errLatin1_80.mat', 'errLatin1_80', '-v7.3')
% callFixieOriginal;
% errLatin2_80 = fixie.err;    
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/errLatin2_80.mat', 'errLatin2_80', '-v7.3')
% callFixieOriginal;
% errLatin3_80 = fixie.err;    
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/errLatin3_80.mat', 'errLatin3_80', '-v7.3')
% callFixieOriginal;
% errLatin4_80 = fixie.err;    
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/errLatin4_80.mat', 'errLatin4_80', '-v7.3')
% callFixieOriginal;
% errLatin5_80 = fixie.err;    
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/errLatin5_80.mat', 'errLatin5_80', '-v7.3')

%% flex reduction case for trial = 1, 65, 129. Comment trial in callPreliminary.
% trial = 1;
% callFixiePODonRv;
% field = 'pre';
% errProposedNouiTujN30InitRefRedu80 = fixie.err;
% errProposedNouiTujN30InitRefRedu80 = rmfield(errProposedNouiTujN30InitRefRedu80, field);
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=1/nouiTuj/errProposedNouiTujN30InitRefRedu80.mat', ...
%     'errProposedNouiTujN30InitRefRedu80', '-v7.3')
% trial = 65;
% callFixiePODonRv;
% field = 'pre';
% errProposedNouiTujN30InitRefRedu80 = fixie.err;
% errProposedNouiTujN30InitRefRedu80 = rmfield(errProposedNouiTujN30InitRefRedu80, field);
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=65/nouiTuj/errProposedNouiTujN30InitRefRedu80.mat', ...
%     'errProposedNouiTujN30InitRefRedu80', '-v7.3')
% trial = 129;
% callFixiePODonRv;
% field = 'pre';
% errProposedNouiTujN30InitRefRedu80 = fixie.err;
% errProposedNouiTujN30InitRefRedu80 = rmfield(errProposedNouiTujN30InitRefRedu80, field);
% save('/home/xiaohan/Desktop/Temp/thesisResults/12052018_2024+rbEnrichRatio/trial=129/nouiTuj/errProposedNouiTujN30InitRefRedu80.mat', ...
%     'errProposedNouiTujN30InitRefRedu80', '-v7.3')

%% POD-Greedy damping case for trial = 1, reduction = 0.6.
% latinSwitch = 1; randomSwitch = 0;
callFixieOriginalDamping;
errLatin1 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errLatin1.mat', 'errLatin1', '-v7.3')
callFixieOriginalDamping;
errLatin2 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errLatin2.mat', 'errLatin2', '-v7.3')
callFixieOriginalDamping;
errLatin3 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errLatin3.mat', 'errLatin3', '-v7.3')
callFixieOriginalDamping;
errLatin4 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errLatin4.mat', 'errLatin4', '-v7.3')
callFixieOriginalDamping;
errLatin5 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errLatin5.mat', 'errLatin5', '-v7.3')
% latinSwitch = 0; randomSwitch = 1;
callFixieOriginalDamping;
errRandom1 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errRandom1.mat', 'errRandom1', '-v7.3')
callFixieOriginalDamping;
errRandom2 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errRandom2.mat', 'errRandom2', '-v7.3')
callFixieOriginalDamping;
errRandom3 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errRandom3.mat', 'errRandom3', '-v7.3')
callFixieOriginalDamping;
errRandom4 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errRandom4.mat', 'errRandom4', '-v7.3')
callFixieOriginalDamping;
errRandom5 = fixie.err;    
save('/home/xiaohan/Desktop/Temp/thesisResults/04062018_1024_POD-Greedy/errRandom5.mat', 'errRandom5', '-v7.3')