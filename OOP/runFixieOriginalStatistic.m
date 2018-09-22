clear; 
%% random
greedySwitch = 0;
randomSwitch = 1; % pseudorandom
structSwitch = 0; % uniform structure
sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 0; % Latin Hypercube
callFixieOriginal;
errRandom1 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom1.mat', ...
    'errRandom1')
callFixieOriginal;
errRandom2 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom2.mat', ...
    'errRandom2')
callFixieOriginal;
errRandom3 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom3.mat', ...
    'errRandom3')
callFixieOriginal;
errRandom4 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom4.mat', ...
    'errRandom4')
callFixieOriginal;
errRandom5 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom5.mat', ...
    'errRandom5')
callFixieOriginal;
errRandom6 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom6.mat', ...
    'errRandom6')
callFixieOriginal;
errRandom7 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errRandom7.mat', ...
    'errRandom7')

%% Latin
greedySwitch = 0;
randomSwitch = 0; % pseudorandom
structSwitch = 0; % uniform structure
sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 1; % Latin Hypercube
callFixieOriginal;
errLatin1 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin1.mat', ...
    'errLatin1')
callFixieOriginal;
errLatin2 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin2.mat', ...
    'errLatin2')
callFixieOriginal;
errLatin3 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin3.mat', ...
    'errLatin3')
callFixieOriginal;
errLatin4 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin4.mat', ...
    'errLatin4')
callFixieOriginal;
errLatin5 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin5.mat', ...
    'errLatin5')
callFixieOriginal;
errLatin6 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin6.mat', ...
    'errLatin6')
callFixieOriginal;
errLatin7 = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errLatin7.mat', ...
    'errLatin7')

%% Sobol
greedySwitch = 0;
randomSwitch = 0; % pseudorandom
structSwitch = 0; % uniform structure
sobolSwitch = 1; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 0; % Latin Hypercube
callFixieOriginal;
errSobol = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errSobol.mat', ...
    'errSobol')

%% Structure
%% Sobol
greedySwitch = 0;
randomSwitch = 0; % pseudorandom
structSwitch = 1; % uniform structure
sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 0; % Latin Hypercube
callFixieOriginal;
errStruct = fixie.err;
save('/Users/kevin/GoogleDrive/thesisResults/11052018_0935+fixRbInc/errStruct.mat', ...
    'errStruct')