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

%% refinement threshold.
refiThres = 0.1;

%% plot surfaces and grids
drawRow = 1;
drawCol = 2;

gridSwitch = 0;
nConsEnd = 1;

%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti, locStartCons, locEndCons, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxValInit, errRbCtrl, ...
    errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol,...
    fNode, ftime, nConsEnd);

% read mass matrix, 2 = 2d.
canti.readMTX2DOF(nDofPerNode);

% read constraint infomation, 2 = 2d.
canti.readINPconsCanti(nDofPerNode);

% read geometric information.
canti.readINPgeo;

% generate parameter space.
canti.generatePmSpace;

% read stiffness matrices, 2 = 2d.
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

% quantity of interest
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

svdSwitch = 0;
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
        
    switch timeType
        
        case 'allTime'
            
            canti.respTimeShift(qoiSwitchTime, qoiSwitchSpace);
            
            switch svdType
                
                case 'noSVD'
                    % CHANGE SIGN in this method!
                    rvSvdSwitch = 1;
                    canti.resptoErrPreCompAllTimeMatrix(rvSvdSwitch);
            end
    end
    % disp('offline end')
    % store reduced variable.
    for iIter = 1:nIter
        
        canti.reducedVar(iIter);
        canti.rvPrepare;
        canti.reducedVarStore(iIter);

    end
    canti.reducedVarSVD;
    
    %% ONLINE
    
    %     disp('online start')
    for iIter = 1:nIter
        
        canti.conditionalItplProdRvPmSVD(iIter);
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    
    a = zeros(25, 25);
    for i = 1:25
        a = a + sqrt(canti.err.store.svdSingle{i}) ./ norm(canti.dis.qoi.trial, 'fro');
        keyboard
    end
    
    keyboard
    % disp('online end')
    %% extract error information    
    canti.extractErrorInfo('hhat');
    canti.extractErrorInfo('hat');
    
    canti.err.max.val.slct = canti.err.max.val.hhat; %
    
    canti.refiCond('maxSurf');
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    canti.extractPmInfo(canti.err.max.loc.hhat, canti.err.max.loc.hhat);
    
    %% local h-refinement.
    if canti.refinement.condition <= canti.refinement.thres
        
        canti.refiCondDisplay('noRefi');
        canti.maxErrorDisplay('hhat');
        
        canti.storeErrorInfo('hhat');
        canti.storeErrorInfo('hat');
        
%         figure(3)
        canti.err.max.pass = canti.err.max.val.hhat;
        canti.err.store.pass = canti.err.store.surf.hhat;
%         canti.plotSurfGrid(drawRow, drawCol, gridSwitch, 1, 'hhat');
        
        if canti.countGreedy >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        
        canti.exactSolution('Greedy');
        % rbEnrichment set the indicators.
        ratioSwitch = 0;
        singularSwitch = 0;
        canti.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ratioSwitch);
        canti.reducedMatrices;
        disp(canti.countGreedy)
        
    elseif canti.refinement.condition > canti.refinement.thres
        
        canti.refiCondDisplay('refi');
        % localHrefinement set the indicators.
        canti.localHrefinement;
        
        canti.extractPmAdd;
        % only compute exact solutions regarding external force
        % when pm domain is refined.
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