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

%% all switches
typeSwitch = 'hhat';
gridSwitch = 0;
qoiSwitchSpace = 0;
qoiSwitchTime = 0;
svdSwitch = 0;
rvSvdSwitch = 1;
ratioSwitch = 0;
singularSwitch = 0;
randomSwitch = 0;

%% data for parameter class.
domLengi = 21;
domLengs = 21;
nIter = prod(domLengi);
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
domBondi = {[bondL1 bondR1]};
nConsEnd = 2;
domMid = cellfun(@(v) (v(1) + v(2)) / 2, domBondi, 'un', 0);
domMid = domMid';

%% data for time.
tMax = 0.19;
tStep = 0.01;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 9;
ftime = 0.02;

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

%% refinement threshold.
refiThres = 0.1;

%% plot surfaces and grids.
drawRow = 1;
drawCol = 1;

%% trial solution.
% use subclass: canbeam to create fixed beam.
fixie = fixbeam(mas, dam, sti, locStartCons, locEndCons, INPname, domLengi, ...
    domLengs, domBondi, domMid, trial, noIncl, noStruct, noMas, noDam, ...
    tMax, tStep, errLowBond, errMaxValInit, errRbCtrl, errRbCtrlThres, ...
    errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, fNode, ftime, nConsEnd);

% read mass matrix, 2 = 2d.
fixie.readMTX2DOF(nDofPerNode);

% read constraint infomation, 2 = 2d.
fixie.readINPconsFixie(nDofPerNode);

% read geometric information.
fixie.readINPgeoMultiInc;

% generate parameter space.
fixie.generatePmSpaceMultiDim;

% read stiffness matrices, 2 = 2d.
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

% quantity of interest
nQoiT = 2;
manual = 1;
fixie.qoiSpaceTime(nQoiT, nDofPerNode, manual);

% compute initial exact solution.
fixie.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace);

% compute initial reduced basis from trial solution.
nPhiInitial = 1;
nPhiEnrich = 1;
fixie.rbInitial(nPhiInitial);
disp(fixie.countGreedy)
fixie.reducedMatrices;
reductionRatio = 0.9;

% initialise interpolation samples.
fixie.initHatPm;
fixie.refineGridLocalwithIdx('initial');

% set types
refindicator = 0;

timeType = 'allTime';
svdType = 'noSVD';
normType = 'fro';

% prepare essential storage for error and responses.
nRespSVD = 2;
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemain;
fixie.impPrepareRemain;
fixie.respStorePrepareRemain(svdType, timeType);

% initial computation of force responses.
fixie.respImpFce(svdSwitch, qoiSwitchTime, qoiSwitchSpace);

%% main while loop.
while fixie.err.max.val.slct > fixie.err.lowBond
    %% OFFLINE.
    %     disp('offline start')
    
    fixie.errPrepareSetZero;
    
    fixie.impGenerate;
    
    fixie.respTdiffComputation(svdSwitch);
        
    switch timeType
        
        case 'allTime'
            
            fixie.respTimeShift(qoiSwitchTime, qoiSwitchSpace);
            
            switch svdType
                
                case 'noSVD'
                    % CHANGE SIGN in this method!
                    fixie.resptoErrPreCompAllTimeMatrix(rvSvdSwitch);
                    
            end
    end
    %     disp('offline end')
    %% ONLINE.
    
    %     disp('online start')
    % collect all reduced variables and perform POD.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.reducedVar;
        
        fixie.rvPrepare;
        
        fixie.rvColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    fixie.rvSVD;
    fixie.rvLTePrervL;
    
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.conditionalItplProdRvPm(iIter, rvSvdSwitch);
        
        fixie.errStoreSurfs('diff');
                
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    
    %     disp('online end')
    %     canti.clearmemory;
    %% extract error information.
    %     canti.extractErrorInfo('errwRb');
    
    fixie.extractMaxErrorInfo('hhat');
    fixie.extractMaxErrorInfo('hat');
    
    fixie.err.max.val.slct = fixie.err.max.val.hhat; %
    
    fixie.refiCond('maxSurf');
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    fixie.extractMaxPmInfo('hhat');
    
    if fixie.refinement.condition <= fixie.refinement.thres
        %% NO local h-refinement.
        fixie.refiCondDisplay('noRefi');
        fixie.maxErrorDisplay('hhat');
        
        fixie.storeErrorInfo('hhat');
        fixie.storeErrorInfo('hat');
        
        figure(1)
        fixie.plotSurfGrid(drawRow, drawCol, gridSwitch, 1, 'hhat');
        
        if fixie.countGreedy >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        
        fixie.exactSolution('Greedy');
        % rbEnrichment set the indicators.
        
        fixie.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ...
            ratioSwitch);
        fixie.reducedMatrices;
        disp(fixie.countGreedy)
       
    elseif fixie.refinement.condition > fixie.refinement.thres
        %% local h-refinement.
        fixie.refiCondDisplay('refi');
        % localHrefinement set the indicators.
        fixie.localHrefinement;
        
        fixie.extractPmAdd;
        
        fixie.respImpFce(svdSwitch, qoiSwitchTime, qoiSwitchSpace);
        
    end
end

% figure(4)
% fixie.plotMaxErrorDecay(fixie.err.store.max.hhat);
%
% figNameSurf = strcat(trialName, 'SVDallVec');
% figPathSurf = strcat(figRoute, figNameSurf);
% savefig(figPathSurf);
%
% figNameDecay = strcat(trialName, 'SVDallVecDecay');
% figPathDecay = strcat(figRoute, 'Decay/', figNameDecay);
% savefig(figPathDecay);