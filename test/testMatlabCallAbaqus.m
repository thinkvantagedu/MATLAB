clear; clc;

jobPath = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
inpName = 'l9h2SingleInc1';
inpPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/';
nnode = 517;
dof = (1:nnode)';
cons = [3 4 7 8 36:44 88:96]';
dof(cons) = [];
% inpName = 'L2H1_dynamics';
% inpPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/cantileverBeam/';
% dof = [2; 4; 5; 6];
% nd = 6;
datName = inpName;
datPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/pmIterModels/';
otptPath = '/home/xiaohan/Desktop/Temp/AbaqusModels/modified/';

% read the entire .inp file.
inpText = fopen(strcat(inpPath, inpName, '.inp'));
rawStrCell = textscan(inpText, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(inpText);
    
% locate the string to be modified.
pmStr = '*Material, name=Material-I1';
fceStrStart = '*Amplitude, name=Amp-af';
fceStrEnd = '** MATERIALS';
for iStr = 1:length(rawStrCell{1})
    if strcmp(rawStrCell{1}{iStr}, pmStr) == 1
        lineStr = iStr;
    elseif strcmp(rawStrCell{1}{iStr}, fceStrStart) == 1
        lineFceStart = iStr;
    elseif strcmp(rawStrCell{1}{iStr}, fceStrEnd) == 1
        lineFceEnd = iStr;
    end
    
end
lineMod = lineStr + 4;

% split the strings, find the num str to be modified. 
splitStr = strsplit(rawStrCell{:}{lineMod});
posRatio = splitStr{2};

% define the logarithm input.
pmInp = 0.00000001;
% set the text file to be written.

otptStrCell = rawStrCell;

for iIter = 1:length(pmInp)
    
    inpNameIter = [otptPath, inpName, '_PmIter.inp'];
    fid = fopen(inpNameIter, 'wt');
    pmIter = pmInp(iIter);
    strIter = [num2str(pmIter), ', ', posRatio];
    otptStrCell{:}(lineMod) = {strIter};
    fprintf(fid, '%s\n', string(otptStrCell{:}));
    fclose(fid);
    % run Abaqus for each pm value.
    cd(datPath)
    runStr = strcat(jobPath, inpName, ' inp=', inpPath, ...
        inpName, '.inp interactive ask_delete=OFF');
    otpt = system(runStr);
    
end

% read the .dat file.

datText = fopen(strcat(datPath, datName, '.dat'));
rawDatCell = textscan(datText, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(datText);

% locate the string to be modified.
datStr = 'THE FOLLOWING TABLE IS PRINTED FOR ALL NODES';

lineStr = [];
for iStr = 1:length(rawDatCell{1})
    if strcmp(strtrim(rawDatCell{1}{iStr}), datStr) == 1
        lineStr = [lineStr; iStr];
    end
end

lineMod = lineStr + 5;

datStore = cell(length(lineMod), 1);
% for iSet = 1:length(lineMod)
for iSet = 1:length(lineMod)
    
    dat_ = {rawDatCell{1}{lineMod(iSet) : lineMod(iSet) + nnode - 1, :}};
    dat_ = dat_';
    dat_ = cellfun(@(v) str2num(v), dat_(:), 'un', 0);
    dat_ = cell2mat(dat_);
    if length(dat_) ~= length(dof)
        dat_ = dat_(dof, :);
    end
    datStore{iSet} = dat_(:, 2:3);
end

disStore = cellfun(@(v) v(:), cellfun(@(v) v', datStore, 'un', 0), 'un', 0);
disStore = cell2mat(disStore');

