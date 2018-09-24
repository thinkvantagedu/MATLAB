clear;
greedySwitch = 1; % Greedy procedure
randomSwitch = 0; % pseudorandom
structSwitch = 0; % uniform structure
sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 0; % Latin Hypercube

runCallIbeamIter;



% domLengi = 9;
% damLeng = 9;
% %% parameter data for trial iteration.
% trial = 81;
% %% plot surfaces and grids. (frequently changes in debugging) ==========
% drawRow = 1;
% drawCol = 25;
% %% random
% greedySwitch = 0;
% randomSwitch = 1; % pseudorandom
% structSwitch = 0; % uniform structure
% sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
% haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
% latinSwitch = 0; % Latin Hypercube
% callIbeamOriginalDamping;
% errRandom1 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom1.mat', ...
%     'errRandom1');
% callIbeamOriginalDamping;
% errRandom2 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom2.mat', ...
%     'errRandom2');
% callIbeamOriginalDamping;
% errRandom3 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom3.mat', ...
%     'errRandom3');
% callIbeamOriginalDamping;
% errRandom4 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom4.mat', ...
%     'errRandom4');
% callIbeamOriginalDamping;
% errRandom5 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom5.mat', ...
%     'errRandom5');
% callIbeamOriginalDamping;
% errRandom6 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errRandom6.mat', ...
%     'errRandom6');

% %% Latin
% greedySwitch = 0;
% randomSwitch = 0; % pseudorandom
% structSwitch = 0; % uniform structure
% sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
% haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
% latinSwitch = 1; % Latin Hypercube
% % callIbeamOriginalDamping;
% % errLatin1 = canti.err;
% % save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin1.mat', ...
% %     'errLatin1');
% callIbeamOriginalDamping;
% errLatin2 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin2.mat', ...
%     'errLatin2');
% callIbeamOriginalDamping;
% errLatin3 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin3.mat', ...
%     'errLatin3');
% callIbeamOriginalDamping;
% errLatin4 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin4.mat', ...
%     'errLatin4');
% callIbeamOriginalDamping;
% errLatin5 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin5.mat', ...
%     'errLatin5');
% callIbeamOriginalDamping;
% errLatin6 = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errLatin6.mat', ...
%     'errLatin6');
% 
% %% Sobol
% greedySwitch = 0;
% randomSwitch = 0; % pseudorandom
% structSwitch = 0; % uniform structure
% sobolSwitch = 1; % Sobol sequence, for 1 and 2 parameters.
% haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
% latinSwitch = 0; % Latin Hypercube
% callIbeamOriginalDamping;
% errSobol = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errSobol.mat', ...
%     'errSobol');
% 
% %% Halton
% greedySwitch = 0;
% randomSwitch = 0; % pseudorandom
% structSwitch = 0; % uniform structure
% sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
% haltonSwitch = 1; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
% latinSwitch = 0; % Latin Hypercube
% callIbeamOriginalDamping;
% errHalton = canti.err;
% save('/home/xiaohan/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225/errHalton.mat', ...
%     'errHalton');

