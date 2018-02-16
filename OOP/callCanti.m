clear; clc;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'l2h1';
lin = 1;
[INPname, mas, sti, locStartCons, locEndCons, noIncl] = ...
    trialCaseSelect(trialName, lin);
noStruct = 1;
noMas = 1;
noDam = 1;
dam = 0;
nDofPerNode = 2;

%% all switches
typeSwitch = 'hhat';
gridSwitch = 0;
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
% SVD on responses. 
svdSwitch = 0;
% SVD on reduced variables.
rvSvdSwitch = 0;
ratioSwitch = 0;
singularSwitch = 0;
randomSwitch = 0;

%% data for parameter class.
domLengi = [15 15];
domLengs = 15;
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
tMax = 0.19;
tStep = 0.01;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.02;
fRange = 10;

%% parameter data for trial iteration.
trial = [1, 1];

%% error informations
errLowBond = 1e-12;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 1e-7;
errRbCtrlTNo = 1;

%% counter
cntInit = 1;

%% refinement threshold.
refiThres = 1e-7;

%% plot surfaces and grids
drawRow = 1;
drawCol = 1;

%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti, locStartCons, locEndCons, INPname, domLengi, ...
    domLengs, domBondi, domMid, trial, noIncl, noStruct, noMas, noDam, ...
    tMax, tStep, errLowBond, errMaxValInit, errRbCtrl, errRbCtrlThres, ...
    errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, fNode, ftime, fRange, ...
    nConsEnd);

% read mass matrix, 2 = 2d.
canti.readMasMTX2DOF(nDofPerNode);

% read constraint infomation, 2 = 2d.
canti.readINPconsCanti(nDofPerNode);

% read geometric information.
canti.readINPgeoMultiInc;

% generate parameter space.
canti.generatePmSpaceMultiDim;

% read stiffness matrices, 2 = 2d.
canti.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
canti.pmTrial;

% initialise damping, velocity, displacement input.
canti.damMtx;
canti.velInpt;
canti.disInpt;

% generate nodal force.
debugMode = 0;
canti.generateNodalFce(nDofPerNode, 0.5, debugMode);

% quantity of interest
nQoiT = 2;
manual = 1;
canti.qoiSpaceTime(nQoiT, nDofPerNode, manual);

% compute initial exact solution.
canti.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace);

% compute initial reduced basis from trial solution.
nPhiInitial = 1;
nPhiEnrich = 2;
canti.rbInitial(nPhiInitial);
disp(canti.countGreedy)
canti.reducedMatrices;
reductionRatio = 0.9;

% initialise interpolation samples.
canti.initHatPm;
canti.refineGridLocalwithIdx('initial');

% set types
refindicator = 0;

timeType = 'allTime';
svdType = 'noSVD';
normType = 'fro';

% prepare essential storage for error and responses.
nRespSVD = 2;
canti.otherPrepare(nRespSVD);
canti.errPrepareRemain;
canti.impPrepareRemain;
canti.respStorePrepareRemain(svdType, timeType);

% initial computation of force responses.
canti.respImpFce(svdSwitch, qoiSwitchTime, qoiSwitchSpace);

%% main while loop
while canti.err.max.val.slct > canti.err.lowBond
    %% OFFLINE
    %     disp('offline start')
    
    canti.errPrepareSetZero;
    
    canti.impGenerate;
    
    canti.respTdiffComputation(svdSwitch);
    
    %     canti.resptoErrPreCompPartTime(qoiSwitchTime, qoiSwitchSpace);
    
    switch timeType
        
        case 'allTime'
            
            canti.respTimeShift(qoiSwitchTime, qoiSwitchSpace, svdSwitch);
            
            switch svdType
                
                case 'noSVD'
                    % CHANGE SIGN in this method!
                    canti.resptoErrPreCompAllTimeMatrix(svdSwitch, rvSvdSwitch);
                    
            end
    end
    %     disp('offline end')
    %% ONLINE
    
    %     disp('online start')
    
    for iIter = 1:nIter
        
        canti.pmIter(iIter);
        
        canti.reducedVar;
        
        canti.pmPrepare;
        
        canti.rvPrepare;
                
        canti.conditionalItplProdRvPm(iIter, rvSvdSwitch);
        
        canti.errStoreSurfs('diff');
                
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    
    %     disp('online end')
    %% extract error information
    %     canti.extractErrorInfo('errwRb');
    
    canti.extractMaxErrorInfo('hhat');
    canti.extractMaxErrorInfo('hat');
    
    canti.err.max.val.slct = canti.err.max.val.hhat; %
    
    canti.refiCond('maxSurf');
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    canti.extractMaxPmInfo('hhat');
    
    if canti.refinement.condition <= canti.refinement.thres
        %% NO local h-refinement.
        canti.refiCondDisplay('noRefi');
        canti.maxErrorDisplay('hhat');
        canti.storeErrorInfo('hhat');
        canti.storeErrorInfo('hat');
        
        figure(3)
        canti.plotSurfGrid(drawRow, drawCol, gridSwitch, 1, 'hhat');
        
        if canti.countGreedy >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        
        canti.exactSolution('Greedy');
        
        % rbEnrichment set the indicators.
        canti.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ...
            ratioSwitch);
        canti.reducedMatrices;
        disp(canti.countGreedy)
        
    elseif canti.refinement.condition > canti.refinement.thres
        %% local h-refinement 
        canti.refiCondDisplay('refi');
        % localHrefinement set the indicators.
        canti.localHrefinement;
        
        canti.extractPmAdd;
        
        canti.respImpFce(svdSwitch, qoiSwitchTime, qoiSwitchSpace);
        
    end
end

% figure(4)
% canti.plotMaxErrorDecay(canti.err.store.max.hhat);
%
% figNameSurf = strcat(trialName, 'SVDallVec');
% figPathSurf = strcat(figRoute, figNameSurf);
% savefig(figPathSurf);
%
% figNameDecay = strcat(trialName, 'SVDallVecDecay');
% figPathDecay = strcat(figRoute, 'Decay/', figNameDecay);
% savefig(figPathDecay);