route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';
oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
cd /home/xiaohan/Desktop/Temp/MATLAB/OOP;
%% data for beam class.
lin = 1;
[INPname, mas, sti, locStartCons, locEndCons, noIncl] = ...
    trialCaseSelect(trialName, lin);
noStruct = 1;
noMas = 1;
noDam = 1;
dam = 0;
nDofPerNode = 2;

%% data for parameter class. ==========
domLengi = 9;
domLengs = 9;
nIter = prod(domLengi);
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
domBondi = {[bondL1 bondR1]};
% Both ends are constrained.
nConsEnd = 2;
domMid = cellfun(@(v) (v(1) + v(2)) / 2, domBondi, 'un', 0);
domMid = domMid';

%% data for time. ==========
tMax = 0.4;
tStep = 0.1;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 9;
ftime = 0.2;
fRange = 5;

%% parameter data for trial iteration.
trial = 1;

%% error informations.
errLowBond = 1e-12;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 0.01;
errRbCtrlTNo = 1;

%% counter.
cntInit = 1;

%% refinement threshold. ==========
refiThres = 0.05;

%% plot surfaces and grids. (frequently changes in debugging) ==========
drawRow = 3;
drawCol = 1;
nPhiInitial = 1;
nPhiEnrich = 1;

%% debug mode for generating nodal force.
debugMode = 0;

%% quantity of interest.
nQoiT = 2;

%% initial error reductions.
% reduction ratio for method: rbSingularInitial and rbReVarInitial.
reductionRatio = 0.9;
% error tolerance for method: rbCtrlInitial.
rbCtrlThres = 0.1;

%% SVD ranks
% number of vectors taking when applying SVD to pre-computed resps.
nRespSVD = 5;
% ratio of SVD erro reduction for POD on rv. ==========
rvSVDreRatio = 1;

%% set types
timeType = 'allTime';
svdType = 'noSVD';
normType = 'fro';

%% all switches
gridSwitch = 0;
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
qoiSwitchManual = 0;
% SVD on responses.
respSVDswitch = 1;
% SVD on reduced variables.
ratioSwitch = 0;
singularSwitch = 0;
randomSwitch = 0;
AbaqusSwitch = 0;

%% Abaqus route and preliminaries.
abaInpFile = ['/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/', ...
    trialName, '.inp'];








