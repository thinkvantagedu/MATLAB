clear; clc;
% this script tests modifying force input of .inp file, 
%% part I: solve the parametric problem using Abaqus, read the output.
% set up the model informations.
nnode = 517;
node = (1:nnode)';
nodeFix = [3 4 7 8 36:44 88:96]';
node(nodeFix) = [];
nnodeFree = length(node);
dofFix = sort([nodeFix * 2; nodeFix * 2 - 1]);
dof = (1:2 * nnode)';
dof(dofFix) = [];
ndofFree = length(dof);
dT = 0.1;
maxT = 0.9;
nd = 1034;
nt = length(0:dT:maxT);

% set up the unmodified inps.
jobDef = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
abaqusPath = '/home/xiaohan/Desktop/Temp/AbaqusModels';
inpNameUnmo = 'l9h2SingleInc_forceMod';
inpPathUnmo = [abaqusPath '/fixBeam/'];

% set up the output .dat file path, same path for all output files.
iterStr = '_iter';
datName = [inpNameUnmo iterStr];
inpPathMo = [abaqusPath '/iterModels/'];

% read the original unmodified .inp file.
inpTextUnmo = fopen([inpPathUnmo, inpNameUnmo, '.inp']);
rawInpStr = textscan(inpTextUnmo, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(inpTextUnmo);

% find the force part to be modified in .inp file.
fceSetStart = '*Nset, nset=Set-af';
fceSetEnd = '*Nset, nset=Set-lc';
fceAmpStart = '*Amplitude';
fceAmpEnd = '** MATERIALS';
fceCloadStart = '*Cload, amplitude';
fceCloadEnd = '** OUTPUT REQUESTS';

for iStr = 1:length(rawInpStr{1})
    strComp = strtrim(rawInpStr{1}{iStr});
    if length(strComp) > 17
        if strcmp(strComp(1:18), fceSetStart) == 1
            lineSetStart = iStr;
        end
        if strcmp(strComp(1:18), fceSetEnd) == 1
            lineSetEnd = iStr;
        end
    end
    if length(strComp) > 11
        if strcmp(strComp(1:10), fceAmpStart) == 1
            lineAmpStart = iStr;
        end
        if strcmp(strComp(1:12), fceAmpEnd) == 1
            lineAmpEnd = iStr;
        end
    end
    if length(strComp) > 17
        if strcmp(strComp(1:17), fceCloadStart) == 1
            lineCloadStart = iStr;
        end
        if strcmp(strComp(1:18), fceCloadEnd) == 1
            lineCloadEnd = iStr;
        end
    end
end


% import the external force for each dof.
load('/home/xiaohan/Desktop/Temp/AbaqusModels/iterModels/fce.mat', 'fce')
% modify part of the inp file where force is defined.
fceAba = fce(:, 1:nt);
fceAmp = zeros(nd, 2 * nt);
fceAmp(:, 1:2:end) = fceAmp(:, 1:2:end) + repmat((0:dT:maxT), [nd, 1]);
fceAmp(:, 2:2:end) = fceAmp(:, 2:2:end) + fceAba;
% write the force information into new .inp file.
setCell = [];
cloadCell = [];
for iNode = 1:nnode
    setStr = ['*Nset, nset=Set-af' num2str(iNode) ', instance=beam-1'];
    setCell_ = {setStr; num2str(iNode)};
    setCell = [setCell; setCell_];
    cload1 = ['*Cload, amplitude=Amp-af' num2str(iNode * 2 - 1)];
    cload2 = ['Set-af' num2str(iNode) ', 1, 1'];
    cload3 = ['*Cload, amplitude=Amp-af' num2str(iNode * 2)];
    cload4 = ['Set-af' num2str(iNode) ', 2, 1'];
    cloadCell = [cloadCell; {cload1; cload2; cload3; cload4}];
    
end
nline = floor(nt * 2 / 8);
ampCell = [];
for iDof = 1:nnode * 2
    ampStr = {['*Amplitude, name=Amp-af' num2str(iDof)]};
    ampVal = fceAmp(iDof, :);
    ampInsLine1 = ampVal(1:nline * 8);
    ampInsLine1 = reshape(ampInsLine1, [8, nline]);
    ampInsCell1 = mat2cell(ampInsLine1', ones(1, nline), 8);
    ampInsCell1 = cellfun(@(v) num2str(v), ampInsCell1, 'un', 0);
    ampInsCell2 = {num2str(ampVal(length(ampVal(1:nline * 8)) + 1:end))};
    ampCell = [ampCell; ampStr; ampInsCell1; ampInsCell2];
end
% set the text file to be written.
% .inp file structure: 
% 1. Beginning to *End Instance (1 - 1498);
% 2. Set-af part;
% 3. *Nset, nset=Set-lc to *End Assembly (1500 - 1508);
% 4. Amp part;
% 5. ** MATERIALS to ** Name: Load-af   Type: Concentrated force (1513 - 1548);
% 6. Cload part;
% 7. ** OUTPUT REQUESTS to end (1552 - 1560).

keyboard
% modified .inp file name.
inpNameMo = [inpNameUnmo, iterStr];
% print the modified .inp file to the output path.

partBeforeSet = rawInpStr{1}(1:lineSetStart - 1);
partSet = setCell;
partBeforeAmp = rawInpStr{1}(lineSetEnd:lineAmpStart - 1);
partAmp = ampCell;
partBeforeCload = rawInpStr{1}(lineAmpEnd:lineCloadStart - 1);
partCload = cloadCell;
partAfterCload = rawInpStr{1}(lineCloadEnd : end);
partAssemble = [partBeforeSet; partSet; partBeforeAmp; partAmp; ...
    partBeforeCload; partCload; partAfterCload];

fid = fopen([inpPathMo inpNameMo, '.inp'], 'wt');
fprintf(fid, '%s\n', string(partAssemble));
fclose(fid);
% run Abaqus for each pm value.
cd(inpPathMo)
runStr = strcat(jobDef, inpNameMo, ' inp=', inpPathMo, ...
    inpNameMo, '.inp interactive ask_delete=OFF');
system(runStr);


