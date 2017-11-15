clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'l9h2SingleInc';
lin = 1;
[INPname, mas, sti, locStartCons, locEndCons] = trialCaseSelect(trialName, lin);
noIncl = 1;
noStruct = 1;
noMas = 1;
noDam = 1;
dam = 0;
nDofPerNode = 2;

%% data for parameter.
domLengi = 25;
domLengs = 25;
nIter = prod(domLengi);
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
domBondi = {[bondL1 bondR1]};
nConsEnd = 2;
domMid = cellfun(@(v) (v(1) + v(2)) / 2, domBondi, 'un', 0);
%% data for time.
tMax = 0.03;
tStep = 0.01; 

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 9;
ftime = 0.02;

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
drawRow = 1;
drawCol = 2;

gridSwitch = 0;

%% trial solution
% use subclass: canbeam to create cantilever beam.
fixie = fixbeam(mas, dam, sti, locStartCons, locEndCons, INPname, domLengi, ...
    domLengs, domBondi, domMid, trial, noIncl, noStruct, noMas, noDam,...
    tMax, tStep, errLowBond, errMaxValInit, errRbCtrl, errRbCtrlThres, ...
    errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, fNode, ftime, nConsEnd);

% read mass matrix. 
fixie.readMTX2DOF(nDofPerNode);

% read constraint infomation.
fixie.readINPconsFixie(nDofPerNode);

% read geometric information.
fixie.readINPgeoMultiInc;

% generate parameter space.
fixie.generatePmSpaceMultiDim;

% read stiffness matrices.
fixie.readMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial;

% initialise damping, velocity, displacement input.
fixie.damMtx;
fixie.velInpt;
fixie.disInpt;

% generate nodal force.
debugMode = 0;
fixie.generateNodalFce(nDofPerNode, 0.5, debugMode);

% quantity of interest.
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
nQoiT = 2;
manual = 1;
fixie.qoiSpaceTime(nQoiT, nDofPerNode, manual);

% compute initial exact solution.
fixie.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace);

% compute initial reduced basis from trial solution. 
nPhiInitial = 1;
nPhiEnrich = 1;
fixie.rbInitial(nPhiInitial);
% rbCtrlThres = 0.1;
% canti.rbCtrlInitial(rbCtrlThres);
reductionRatio = 0.9; 
% canti.rbSingularInitial(reductionRatio);
% canti.rbReVarInitial(reductionRatio);
disp(fixie.countGreedy)
fixie.reducedMatrices;
fixie.errPrepareRemainOriginal;

normType = 'fro';

while fixie.err.max.val.slct > fixie.err.lowBond
    %% ONLINE
    fixie.errPrepareSetZeroOriginal;
    
    for iIter = 1:nIter
        
        fixie.reducedVar(iIter);
        
        fixie.residualfromForce(normType, qoiSwitchSpace, qoiSwitchTime);
        
        fixie.errStoreSurfs('original');
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    
    randomSwitch = 0;
    fixie.extractErrorInfo('original', randomSwitch);
    fixie.extractPmInfo(fixie.err.max.loc, fixie.err.max.loc);
    fixie.storeErrorInfoOriginal;
    
    figure(1)
    fixie.err.max.pass = fixie.err.max.val.slct;
    fixie.err.store.pass = fixie.err.store.surf;
    
    if fixie.countGreedy == 1
        axisLim = fixie.err.max.val.slct;
    end
    
    fixie.plotSurfGrid(drawRow, drawCol, gridSwitch, axisLim, 'original');
    
    fixie.maxErrorDisplay('original');
    if fixie.countGreedy >= drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    
    fixie.exactSolution('Greedy');
    
    ratioSwitch = 1;
    singularSwitch = 0;
    fixie.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ratioSwitch);
    fixie.reducedMatrices;
    disp(fixie.countGreedy)
    
end
%%
% figure(2)
% fixie.plotMaxErrorDecay(fixie.err.store.max);