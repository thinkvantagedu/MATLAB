clear; clc;
%% part I: solve the parametric problem using Abaqus, read the output.
% set up the model informations.
nnode = 517;
node = (1:nnode)';
nodeFix = [3 4 7 8 36:44 88:96]';
node(nodeFix) = [];
dofFix = sort([nodeFix * 2; nodeFix * 2 - 1]);

% set up the unmodified inps.
jobDef = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
abaqusPath = '/home/xiaohan/Desktop/Temp/AbaqusModels';
inpNameUnmo = 'l9h2SingleInc';
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
pmIstr = '*Material, name=Material-I1';
pmSstr = '*Material, name=Material-S';
fceStrStart = '*Amplitude, name=Amp-af';
fceStrEnd = '** MATERIALS';
for iStr = 1:length(rawInpStr{1})
    if strcmp(rawInpStr{1}{iStr}, pmIstr) == 1
        lineIstrStart = iStr;
    elseif strcmp(rawInpStr{1}{iStr}, pmSstr) == 1
        lineSstrStart = iStr;
    elseif strcmp(rawInpStr{1}{iStr}, fceStrStart) == 1
        lineFceStart = iStr;
    elseif strcmp(rawInpStr{1}{iStr}, fceStrEnd) == 1
        lineFceEnd = iStr;
    end
    
end
lineImod = lineIstrStart + 4;
lineSmod = lineSstrStart + 4;
lineFceStart = lineFceStart + 1;
lineFceEnd = lineFceEnd - 2;

% split the strings, find the num str to be modified.
splitStr = strsplit(rawInpStr{:}{lineImod});
posRatio = splitStr{end};

% define the logarithm input for inclusion and matrix.
pmIinp = 10;
pmS = 1000;

% set the text file to be written.
otptInpStr = rawInpStr;
% iteratively execute the Abaqus job.
for iIter = 1:length(pmIinp)
    % modified inp file name.
    inpNameMo = [inpNameUnmo, iterStr];
    % print the modified inp file to the output path.
    fid = fopen([inpPathMo inpNameMo, '.inp'], 'wt');
    % modify inclusion and matrix values individually.
    pmIiter = pmIinp(iIter);
    strIiter = [' ', num2str(pmIiter), ', ', posRatio];
    strS = [' ', num2str(pmS), ', ', posRatio];
    otptInpStr{:}(lineImod) = {strIiter};
    otptInpStr{:}(lineSmod) = {strS};
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
datStrStart = 'THE FOLLOWING TABLE IS PRINTED FOR';
datStrEnd = 'AT NODE';
lineIstrStart = [];
lineStrEnd = [];

for iStr = 1:length(rawDatStr{1})
    % define string to compare.
    datStrComp = strtrim(rawDatStr{1}{iStr});
    % compare the start string for nodal output.
    if length(datStrComp) > 33
        datStrCompStart = datStrComp(1:34);
        if strcmp(datStrCompStart, datStrStart) == 1
            lineIstrStart = [lineIstrStart; iStr];
        end
    end
    % compare the end string for nodal output.
    if length(datStrComp) > 6
        datStrCompEnd = datStrComp(1:7);
        if strcmp(datStrCompEnd, datStrEnd) == 1
            lineStrEnd = [lineStrEnd; iStr];
        end
    end
end

% find the locations of displacement outputs.
lineModStart = lineIstrStart + 5;
lineModEnd = lineStrEnd(1:2:end) - 3;

% transform and store the displacement outputs.
disAllStore = cell(length(lineModStart), 1);
for iDis = 1:length(lineModStart)
    
    dis_ = rawDatStr{1}(lineModStart(iDis) : lineModEnd(iDis));
    dis_ = str2num(cell2mat(dis_));
    % fill non-exist spots with 0s.
    if size(dis_, 1) ~= nnode
        
        disAllDof = zeros(nnode, 3);
        disAllDof(dis_(:, 1), :) = dis_;
        disAllDof(:, 1) = (1:nnode);
    end
    disAllStore(iDis) = {disAllDof};
    
end
% reshape these u1 u2 displacements to standard space-time vectors, first
% extract displacements without indices.
disValStore = cellfun(@(v) v(:, 2:3), disAllStore, 'un', 0);
disVecStore = cellfun(@(v) v', disValStore, 'un', 0);
disVecStore = cellfun(@(v) v(:), disVecStore, 'un', 0);

dis = cell2mat(disVecStore');

%% how to check the results obtained from invoking Abaqus?
% set the pm values for inclusion and matrix the same as the trial values of
% callFixieOriginal, run this test first, obtain norm(disValStore, 'fro'),
% then run callFixieOriginal, obtain norm(fixie.dis.trial, 'fro').

% read mas matrix.
masMtxFile = [abaqusPath, '/iterModels/', 'l9h2SingleInc_iter_MASS1.mtx'];
ASM = dlmread(masMtxFile);
indI = zeros(length(ASM), 1);
indJ = zeros(length(ASM), 1);
Node_n = max(ASM(:,1));    %or max(ASM(:,3))
ndof = Node_n * 2;
for ii = 1:size(ASM,1)
    indI(ii) = 2 * (ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = 2 * (ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI, indJ, ASM(:, 5), ndof, ndof);

masMtx = M' + M;

for i_tran = 1:length(M)
    masMtx(i_tran, i_tran) = masMtx(i_tran, i_tran) / 2;
end

% read stiffness matrix.
stiMtxFile = [abaqusPath, '/iterModels/', 'l9h2SingleInc_iter_STIF1.mtx'];
ASM = dlmread(stiMtxFile);

for ii=1:size(ASM, 1)
    indI(ii) = 2 * (ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = 2 * (ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI,indJ,ASM(:, 5),ndof, ndof);
stiMtx = M' + M;

for i_tran=1:length(M)
    stiMtx(i_tran, i_tran) = stiMtx(i_tran, i_tran) / 2;
end

diagindx = (dofFix - 1) * (ndof + 1) + 1;
stiMtx(dofFix, :) = 0;
stiMtx(:, dofFix) = 0;
stiMtx(diagindx) = 1;

% read force information.
fceCell = rawInpStr{1}(lineFceStart:lineFceEnd);
fce = [];
for iFce = 1:length(fceCell)
    
    fce_ = str2num(cell2mat(fceCell(iFce)));
    fce = [fce; fce_'];
    
end

fce = fce(2:2:end);
fceVal = sparse(nnode * 2, length(lineModStart) + 1);
fceVal(18, 1:length(fce)) = fceVal(18, 1:length(fce)) - fce';

u0 = zeros(nnode * 2, 1);
v0 = zeros(nnode * 2, 1);
phi = eye(nnode * 2);

dT = 0.1;
maxT = 9.9;

[~, ~, ~, u, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, masMtx, zeros(nnode * 2), stiMtx, fceVal, ...
    'average', dT, maxT, u0, v0);

%% plot the first N displacements with subplot.
x = 0.1:0.1:9.9;
y = 0:0.1:9.9;
figure
for iPlot = 1020:1028
    subplot(3, 3, iPlot - 1019)
    plot(x, dis(iPlot, :), '->', 'LineWidth', 2)
    hold on
    plot(y, u(iPlot, :), '-*', 'LineWidth', 2)
    grid minor
end





























