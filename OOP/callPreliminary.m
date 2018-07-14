%% data for beam class.
lin = 1;
if lin == 1
    oopPath = '/home/xiaohan/Desktop/Temp/MATLAB/OOP';
    cd /home/xiaohan/Desktop/Temp/MATLAB/OOP/@beam;
elseif lin == 0
    oopPath = '/Users/kevin/Documents/OOP';
    cd /Users/kevin/Documents/OOP/@beam;
end

addpath(genpath(oopPath));
[INPname, mas, sti, locStartCons, locEndCons, noIncl] = ...
    trialCaseSelect(trialName, lin);
noStruct = 1;
noMas = 1;
noDam = 1;
dam = 0;

%% data for parameter class. ==========
domLengi = 17;
damLeng = 17;
damBond = [-1 1];

nIter = prod(domLengi);
bondL1 = -1;
bondR1 = 1;
bondL2 = -1;
bondR2 = 1;
domBondi = {[bondL1 bondR1]};
% Both ends are constrained.

domMid = cellfun(@(v) (v(1) + v(2)) / 2, domBondi, 'un', 0);
domMid = domMid';

%% data for time. ==========
tMax = 4.9;
tStep = 0.1;

%% data for external nodal force.
% fNode needs to be manually updated.
ftime = 0.2;
fRange = 10;

%% parameter data for trial iteration.
trial = 1;

%% error informations.
errLowBond = 1e-10;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 0.01;
errRbCtrlTNo = 1;

%% count Greedy.
cntInit = 0;

%% refinement threshold. ==========
refiThres = 0.25;

%% plot surfaces and grids. (frequently changes in debugging) ==========
drawRow = 1;
drawCol = 12;
nPhiInitial = 10;
nPhiEnrich = 4;

%% debug mode for generating nodal force.
debugMode = 0;

%% quantity of interest.
nQoiT = 2;

%% error reductions.
% reduction ratio: ||u-ur||_F / ||u0||_F, compare against the previous
% maximum error.
reductionRatio = 0.6;
% error tolerance for method: rbCtrlInitial.
% rbCtrlThres = 0.01;

%% SVD ranks
% number of vectors taking when applying SVD to pre-computed resps.
nRespSVD = 25; 
% ratio of SVD error reduction for POD on rv. ==========
rvSVDreRatio = 1;

%% set types
timeType = 'allTime';

%% all switches
% QoI switches, qoiSwitchManual manually set QoI.
qoiSwitchSpace = 1;
qoiSwitchTime = 1;
% SVD on responses.
respSVDswitch = 1;
% ratioSwitch iteratively add basis vector based on RB error,
ratioSwitch = 1;
% randomSwtich randomly select magic points, works for original only.
AbaqusSwitch = 0;
% refCeaseSwitch ceases refinement when refines more than once.
refCeaseSwitch = 0;

%% Abaqus route and preliminaries.
abaInpFile = ['/home/xiaohan/Desktop/Temp/AbaqusModels/fixBeam/', ...
    trialName, '.inp'];

%% test cases. 1 at a time. Only 1 switch equals to 1 each test. 
greedySwitch = 0; % Greedy procedure
randomSwitch = 0; % pseudorandom
structSwitch = 0; % uniform structure
sobolSwitch = 0; % Sobol sequence, for 1 and 2 parameters.
haltonSwitch = 0; % Halton sequence, for 1 and 2 parameters.(1d Halton = Sobol).
latinSwitch = 1; % Latin Hypercube