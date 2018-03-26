clear; clc;
% this script tests running .inp file exported from callFixiePODonRv.m, after 
% runnning respTdiffComputation. 
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
maxT = 4.9;
nd = 1034;
nt = length(0:dT:maxT);

% set up the unmodified inps.
jobDef = '/home/xiaohan/abaqus/6.14-1/code/bin/abq6141 noGUI job=';
abaqusPath = '/home/xiaohan/Desktop/Temp/AbaqusModels';
inpNameUnmo = 'l9h2SingleInc';

iterStr = '_iter';
datName = [inpNameUnmo iterStr];
inpPathMo = [abaqusPath '/iterModels/'];
cd(inpPathMo)
inpNameMo = 'l9h2SingleInc_iter';
runStr = strcat(jobDef, inpNameMo, ' inp=', inpPathMo, ...
    inpNameMo, '.inp interactive ask_delete=OFF');
system(runStr);

%% 
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