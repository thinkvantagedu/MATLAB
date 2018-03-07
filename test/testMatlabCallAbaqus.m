clear; clc;
% set up the model informations.
nnode = 517;
node = (1:nnode)';
nodeFix = [3 4 7 8 36:44 88:96]';
node(nodeFix) = [];

% set up the unmodified inps.
jobDef = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
abaqusPath = '/home/xiaohan/Desktop/Temp/AbaqusModels';
inpNameUnmo = 'l9h2SingleInc1';
inpPathUnmo = [abaqusPath '/fixBeam/'];

% set up the output .dat file path, same path for all output files.
iterStr = '_iter';
datName = [inpNameUnmo iterStr];
inpPathMo = [abaqusPath '/iterModels/'];

% read the original unmodified .inp file.
inpTextUnmo = fopen([inpPathUnmo, inpNameUnmo, '.inp']);
rawInpStr = textscan(inpTextUnmo, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(inpTextUnmo);

% locate the strings to be modified.
pmStr = '*Material, name=Material-I1';
fceStrStart = '*Amplitude, name=Amp-af';
fceStrEnd = '** MATERIALS';
for iStr = 1:length(rawInpStr{1})
    if strcmp(rawInpStr{1}{iStr}, pmStr) == 1
        lineStrStart = iStr;
    elseif strcmp(rawInpStr{1}{iStr}, fceStrStart) == 1
        lineFceStart = iStr;
    elseif strcmp(rawInpStr{1}{iStr}, fceStrEnd) == 1
        lineFceEnd = iStr;
    end
    
end
lineMod = lineStrStart + 4;

% split the strings, find the num str to be modified.
splitStr = strsplit(rawInpStr{:}{lineMod});
posRatio = splitStr{end};

% define the logarithm input.
pmInp = 10;

% set the text file to be written.
otptInpStr = rawInpStr;
% iteratively execute the Abaqus job.
for iIter = 1:length(pmInp)
    % modified inp file name.
    inpNameMo = [inpNameUnmo, iterStr];
    % print the modified inp file to the output path.
    fid = fopen([inpPathMo inpNameMo, '.inp'], 'wt');
    pmIter = pmInp(iIter);
    strIter = [' ', num2str(pmIter), ', ', posRatio];
    otptInpStr{:}(lineMod) = {strIter};
    fprintf(fid, '%s\n', string(otptInpStr{:}));
    fclose(fid);
    % run Abaqus for each pm value.
    cd(inpPathMo)
    runStr = strcat(jobDef, inpNameMo, ' inp=', inpPathMo, ...
        inpNameMo, '.inp interactive ask_delete=OFF');
    system(runStr);
    
end

% read the .dat file.
datText = fopen([inpPathMo, datName, '.dat']);
rawDatStr = textscan(datText, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(datText);

% locate the strings to be modified.
datStrStart = 'THE FOLLOWING TABLE IS PRINTED FOR ALL NODES';
datStrEnd = 'AT NODE';
lineStrStart = [];
lineStrEnd = [];
for iStr = 1:length(rawDatStr{1})
    datStrComp = strtrim(rawDatStr{1}{iStr});
    if strcmp(datStrComp, datStrStart) == 1
        lineStrStart = [lineStrStart; iStr];
    end
    if length(datStrComp) > 6
        datStrCompEnd = datStrComp(1:7);
        if strcmp(datStrCompEnd, datStrEnd) == 1
            lineStrEnd = [lineStrEnd; iStr];
        end
    end
end

lineModStart = lineStrStart + 5;
lineModEnd = lineStrEnd(1:2:end);
