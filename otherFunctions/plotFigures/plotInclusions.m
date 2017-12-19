clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));

%% data for beam class.
trialName = 'l9h2SingleInc';
lin = 1;
[INPname, mas, sti, locStartCons, locEndCons, noIncl] = ...
    trialCaseSelect(trialName, lin);
noStruct = 1;
noMas = 1;
noDam = 1;
dam = 0;
nDofPerNode = 2;

%% all switches
typeSwitch = 'original';
gridSwitch = 0;
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
svdSwitch = 0;
rvSvdSwitch = 0;
ratioSwitch = 0;
singularSwitch = 0;
randomSwitch = 0;

%% data for parameter class.
domLengi = 5;
domLengs = 5;
nIter = prod(domLengi);
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
domBondi = {[bondL1 bondR1]; [bondL2 bondR2]};
nConsEnd = 1;
domMid = cellfun(@(v) (v(1) + v(2)) / 2, domBondi, 'un', 0);
domMid = domMid';

%% data for time
tMax = 0.03;
tStep = 0.01;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.02;
fRange = 10;

%% parameter location for trial iteration.
trial = 1;

%% error informations
errLowBond = 1e-12;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 0.01;
errRbCtrlTNo = 1;

%% counter
cntInit = 1;

%% refinement threshold.
refiThres = 0.0002;

%% plot surfaces and grids
drawRow = 2;
drawCol = 5;

%% trial solution
% use subclass: canbeam to create cantilever beam.
fixie = canbeam(mas, dam, sti, locStartCons, locEndCons, INPname, domLengi, ...
    domLengs, domBondi, domMid, trial, noIncl, noStruct, noMas, noDam, ...
    tMax, tStep, errLowBond, errMaxValInit, errRbCtrl, errRbCtrlThres, ...
    errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, fNode, ftime, fRange, ...
    nConsEnd);
% read mass matrix.
fixie.readMTX2DOF(nDofPerNode);
plotMeshSwitch = 1;
fixie.readINPgeoMultiIncPlot(plotMeshSwitch, [1 1 0.5], [0.2 0.5 1]);
set(gca, 'Fontsize', 25);
axis equal
