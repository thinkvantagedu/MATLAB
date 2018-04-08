clear; clc;
trialName = 'l9h2SingleInc';
typeSwitch = 'hhat';
rvSVDswitch = 1;
callPreliminary;

%% trial solution.
% use subclass: fixbeam to create beam.
fixie = fixbeam(abaInpFile, mas, dam, sti, locStartCons, locEndCons, ...
    INPname, domLengi, domBondi, domMid, trial, noIncl, noStruct, ...
    noMas, noDam, tMax, tStep, errLowBond, errMaxValInit, ...
    errRbCtrl, errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
    drawRow, drawCol, fNode, ftime, fRange, nConsEnd);

% read mass matrix.
fixie.readMasMTX2DOF(nDofPerNode);

% read constraint infomation.
fixie.readINPconsFixie(nDofPerNode);

% read geometric information.
fixie.readINPgeoMultiInc;

% generate parameter space.
fixie.generatePmSpaceMultiDim;

% read stiffness matrices.
fixie.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial;

% initialise damping, velocity, displacement input.
fixie.damMtx;
fixie.velInpt;
fixie.disInpt;

% generate nodal force.
fixie.generateNodalFce(nDofPerNode, 0.3, debugMode);

% quantity of interest.
fixie.qoiSpaceTime(nQoiT, nDofPerNode, qoiSwitchManual);

% compute initial exact solution.
fixie.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace, ...
    AbaqusSwitch, trialName);

% compute initial reduced basis from trial solution.
fixie.rbInitial(nPhiInitial);
disp(fixie.countGreedy)
fixie.reducedMatrices;

% initialise interpolation samples.
fixie.initHatPm;
fixie.refineGridLocalwithIdx('initial');

% prepare essential storage for error and responses.
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemainHats;
fixie.impPrepareRemain;
fixie.respStorePrepareRemain(timeType);

% initial computation of force responses.
fixie.respfromFce(respSVDswitch, qoiSwitchTime, qoiSwitchSpace, ...
    AbaqusSwitch, trialName);

%% main while loop.
while fixie.err.max.val.hhat > fixie.err.lowBond
    %% OFFLINE.
    % disp('offline start')
    fixie.errPrepareSetZero;
    
    % OFFLINE POD.
    % collect all reduced variables to perform POD.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.reducedVar;
        
        fixie.pmPrepare(rvSVDswitch);
        
        fixie.rvPrepare(rvSVDswitch);
        
        fixie.pmMultiRv;
        
        fixie.rvpmColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    fixie.rvSVD(rvSVDreRatio);
    
    fixie.impGenerate;
    
    fixie.respTdiffComputation(respSVDswitch, AbaqusSwitch, trialName);
    
    switch timeType
        
        case 'allTime'
            
            fixie.respTimeShift(qoiSwitchTime, qoiSwitchSpace, respSVDswitch);
    end
    
    % CHANGE SIGN in this method!
    fixie.resptoErrPreCompAllTimeMatrix2(respSVDswitch, rvSVDswitch);

    % disp('offline end')
    
    %% ONLINE.
    % disp('online start')
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.conditionalItplProdRvPm(iIter, rvSVDswitch);
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    % disp('online end')
    
    %% extract error information.
    fixie.errStoreSurfs('diff');
    fixie.extractMaxErrorInfo('hhat');
    fixie.extractMaxErrorInfo('hat');
    fixie.refiCond('maxSurf');
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    fixie.extractMaxPmInfo(typeSwitch);
    
    if fixie.refinement.condition <= fixie.refinement.thres
        %% NO local h-refinement.
        fixie.maxErrorDisplay(typeSwitch);
        fixie.storeErrorInfo;
        fixie.errStoreAllSurfs(typeSwitch);
        figure(1)
        fixie.plotSurfGrid(drawRow, drawCol, gridSwitch, 1, ...
            typeSwitch, 'g-*');
        
        if fixie.countGreedy >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        
        fixie.exactSolution('Greedy', ...
            qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch);
        
        % rbEnrichment set the indicators.
        fixie.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ...
            ratioSwitch);
        fixie.reducedMatrices;
        disp(fixie.countGreedy)
        
    elseif fixie.refinement.condition > fixie.refinement.thres
        %% local h-refinement.
        fixie.localHrefinement;
                
        fixie.respfromFce(respSVDswitch, ...
            qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch);
        
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