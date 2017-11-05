clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'l2h1';
lin = 1;
[INPname, mas, sti, locStartCons, locEndCons] = trialCaseSelect(trialName, lin);
noIncl = 2;
dam = 0;
nDofPerNode = 2;

%% data for parameter class.
domLeng1 = 5;
domLeng2 = 5;
domLengs = 5;
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
tMax = 0.03;
tStep = 0.01; 

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.02;

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
drawRow = 1;
drawCol = 1;

gridSwitch = 0;
nConsEnd = 1;
%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti, locStartCons, locEndCons, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxValInit, ...
    errRbCtrl, errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
    drawRow, drawCol, fNode, ftime, nConsEnd);

% read mass matrix.
canti.readMTX2DOF(nDofPerNode);

% read constraint infomation.
canti.readINPconsCanti(nDofPerNode);

% read geometric information.
canti.readINPgeoMultiInc;

% generate parameter space.
canti.generatePmSpaceMultiDim;

% read stiffness matrices.
canti.readMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
canti.pmTrial;

% initialise damping, velocity, displacement input.
canti.damMtx;
canti.velInpt;
canti.disInpt;

% generate nodal force.
debugMode = 0;
canti.generateNodalFce(nDofPerNode, 0.5, debugMode);

% quantity of interest.
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
nQoiT = 2;
manual = 1;
canti.qoiSpaceTime(nQoiT, nDofPerNode, manual);

% compute initial exact solution.
canti.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace);

% compute initial reduced basis from trial solution. 
nPhiInitial = 1;
nPhiEnrich = 1;
canti.rbInitial(nPhiInitial);
% rbCtrlThres = 0.1;
% canti.rbCtrlInitial(rbCtrlThres);
reductionRatio = 0.9; 
% canti.rbSingularInitial(reductionRatio);
% canti.rbReVarInitial(reductionRatio);
disp(canti.countGreedy)
canti.reducedMatrices;
canti.errPrepareRemainOriginal;

normType = 'fro';

while canti.err.max.val.slct > canti.err.lowBond
    %% ONLINE
    canti.errPrepareSetZeroOriginal;
    
    for iIter = 1:nIter
        
        canti.reducedVar(iIter);
        
        canti.residualfromForce(normType, qoiSwitchSpace, qoiSwitchTime);
        
        canti.errStoreSurfs('original');
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    
    randomSwitch = 0;
    canti.extractErrorInfo('original', randomSwitch);
    canti.extractPmInfo(canti.err.max.loc, canti.err.max.loc);
    canti.storeErrorInfoOriginal;
    
    figure(1)
    
    if canti.countGreedy == 1
        axisLim = canti.err.max.val.slct;
    end
    
    canti.plotSurfGrid(drawRow, drawCol, gridSwitch, axisLim, 'original');
    
    canti.maxErrorDisplay('original');
    if canti.countGreedy >= drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    
    canti.exactSolution('Greedy');
    
    ratioSwitch = 0;
    singularSwitch = 0;
    canti.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ratioSwitch);
    canti.reducedMatrices;
    disp(canti.countGreedy)
    
end
%%
figure(2)
canti.plotMaxErrorDecay(canti.err.store.max);