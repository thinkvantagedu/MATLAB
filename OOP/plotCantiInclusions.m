clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'l9h2_multiInc';
lin = 1;
[INPname, mas, sti1, sti2, stis, locStart, locEnd] = ...
    trialCaseSelection(trialName, lin);
noIncl = 10;
dam = 0;
nDofPerNode = 2;

%% data for parameter class.
domLeng1 = 9;
domLeng2 = 9;
domLengs = 9;
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
nIter = domLeng1 * domLeng2;
% mid 1 and 2 are used for refinement, middle points are needed for the
% initial refinements.
mid1 = (bondL1 + bondR1) / 2;
mid2 = (bondL2 + bondR2) / 2;

%% data for time
tMax = 0.99;
tStep = 0.01; 

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.06;

%% parameter location for trial iteration.
trial = [1, 1];

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

gridSwitch = 0;
plotMeshSwitch = 1;
%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti1, sti2, stis, locStart, locEnd, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxValInit, errRbCtrl, ...
    errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, ...
    fNode, ftime);
% read mass matrix.
canti.readMTX2DOF(nDofPerNode);

canti.readINPgeoMultiIncPlot(plotMeshSwitch, [1 1 0.5], [0.2 0.5 1]);