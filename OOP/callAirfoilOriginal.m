clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'airfoilMedium';
lin = 1;
[INPname, mas, sti1, sti2, stis, locStart, locEnd] = ...
    trialCaseSelection(trialName, lin);
noIncl = 3;
dam = 0;
nDofPerNode = 3;

%% data for parameter class.
domLeng1 = 17;
domLeng2 = 17;
domLengs = 17;
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
tMax = 99;
tStep = 1;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.06;

%% parameter data for trial iteration.
trial = [1, 1];

%% error informations
errLowBond = 1e-12;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 0.01;
errRbCtrlTNo = 1;

%% counter
cntInit = 1;

%% refinement
refiThres = 0.01;

%% plot surfaces and grids
drawRow = 2;
drawCol = 3;

gridSwitch = 0;

%% trial solution
% use subclass: canbeam to create cantilever beam l2h1.
canti = canbeam(mas, dam, sti1, sti2, stis, locStart, locEnd, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxValInit, errRbCtrl, ...
    errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, ...
    fNode, ftime);

% read mass matrix.
canti.readMTX2DOF(nDofPerNode);

% read constraint infomation.
canti.readINPcons(nDofPerNode);

% read geometric information.
canti.readINPgeo;

% generate parameter space.
canti.generatePmSpace;

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
nPhiInitial = 14;
nPhiEnrich = 41;
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
keyboard
while canti.err.max.val > canti.err.lowBond
    
    if canti.countIter == 1
        
        canti.rbCtrlInitial(errRbCtrlThres);
        
        canti.approSolution('initial');
        
    elseif canti.countIter > 1;
        
        canti.rbEnrichment;
        
        canti.approSolution('iter');
        
    end
    
    %% ONLINE
    canti.err.store.surf = zeros(canti.domLeng.I1, canti.domLeng.I2);
    for i_iter = 1:length(canti.pmVal.comb.space)
        
        canti.reducedVar(i_iter);
        
        canti.residualfromForce(i_iter);
        disp(i_iter)
    end
    
    canti.extractErrorInfo(canti.err.store.surf);
    canti.err.max.val = canti.err.max.valExt;
    
    canti.extractPmInfo(canti.err.max.loc);
    canti.storeErrorInfoOriginal;
    
    figure(1)
    canti.err.max.pass = canti.err.max.val;
    canti.err.store.pass = canti.err.store.surf;
    axisLim = canti.err.max.val;
    canti.plotSurfGrid(drawRow, drawCol, viewX, viewY, gridSwitch, axisLim);
    
    if canti.countIter >= drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    disp(canti.countIter)
    canti.countIter = canti.countIter + 1;
    
end

figure(2)
canti.plotMaxErrorDecay(canti.err.store.max);