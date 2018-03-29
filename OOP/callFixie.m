clear; clc;
trialName = 'l9h2SingleInc';
typeSwitch = 'hhat';
rvSVDswitch = 0;
callPreliminary;

%% trial solution
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
fixie.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch);

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
fixie.respStorePrepareRemain(svdType, timeType);

% initial computation of force responses.
fixie.respfromFce(respSVDswitch, qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch);

%% main while loop.
while fixie.err.max.val.hhat > fixie.err.lowBond
    %% OFFLINE
    % disp('offline start')
    fixie.errPrepareSetZero;
    
    fixie.impGenerate;
    
    fixie.respTdiffComputation1(respSVDswitch, AbaqusSwitch);
    
    switch timeType
        
        case 'allTime'
            
            fixie.respTimeShift(qoiSwitchTime, qoiSwitchSpace, respSVDswitch);
            
            switch svdType
                
                case 'noSVD'
                    
                    % CHANGE SIGN in this method!
                    fixie.resptoErrPreCompAllTimeMatrix...
                        (respSVDswitch, rvSVDswitch);
                    
            end
    end
    % disp('offline end')
    %% ONLINE
    
    % disp('online start')
    
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.reducedVar;
        
        fixie.pmPrepare(rvSVDswitch);
        
        fixie.rvPrepare(rvSVDswitch);
        
        fixie.conditionalItplProdRvPm(iIter, rvSVDswitch);
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
    % disp('online end')
    
    %% extract error information
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
        fixie.refiCondDisplay('noRefi');
        fixie.maxErrorDisplay('hhat');
        fixie.storeErrorInfo('hhat');
        fixie.storeErrorInfo('hat');
        fixie.errStoreAllSurfs(typeSwitch);
        figure(1)
        fixie.plotSurfGrid(drawRow, drawCol, gridSwitch, 1, ...
            typeSwitch, 'b-^');
        
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
        %% local h-refinement
        fixie.refiCondDisplay('refi');
        % localHrefinement set the indicators.
        fixie.localHrefinement;
        
        fixie.extractPmAdd;
        
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