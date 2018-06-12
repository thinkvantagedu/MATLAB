% this is the implemented callFixie without damping.

clear; clc;
trialName = 'l9h2SingleInc';
rvSVDswitch = 1;
callPreliminary;
noPm = 2;

%% trial solution.
% use subclass: fixbeam to create beam.
fixie = fixbeam(abaInpFile, mas, dam, sti, locStartCons, locEndCons, ...
    INPname, domLengi, domBondi, domMid, trial, noIncl, noStruct, noPm, ...
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
fixie.generatePmSpaceSingleDim(structSwitch, drawRow, drawCol);

% generate damping coefficient space, the combination is stiffness then damping.
damLeng = 4;
damBond = [-1 1];
fixie.generateDampingSpace(damLeng, damBond);

% read stiffness matrices.
fixie.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial(1);

% initialise damping, velocity, displacement input.
fixie.damMtx;
fixie.velInpt;
fixie.disInpt;

% generate nodal force.
fixie.generateNodalFce(nDofPerNode, 0.3, debugMode);

% quantity of interest.
fixie.qoiSpaceTime(qoiSwitchSpace, qoiSwitchTime);

% initialise interpolation samples.
fixie.initHatPm;
fixie.refineGridLocalwithIdx('initial');
% prepare essential storage for error and responses.
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemainProp;

% compute initial exact solution.
fixie.exactSolutionDynamic('initial', AbaqusSwitch, trialName, 1);

% compute initial reduced basis from trial solution.
fixie.rbInitial(nPhiInitial, reductionRatio, ratioSwitch, 'hhat', 1);
fixie.reducedMatricesStatic;
fixie.reducedMatricesDynamic;

fixie.impPrepareRemain;
fixie.respStorePrepareRemain(timeType);

% initial computation of force responses.
fixie.respfromFce(respSVDswitch, AbaqusSwitch, trialName, 1);

%% main while loop.
while fixie.err.max.val.hhat > fixie.err.lowBond
    if fixie.countGreedy == drawRow * drawCol
        % put here to stop any uncessary computations.
        disp('iterations reach maximum plot number')
        break
    end
    %% Greedy OFFLINE.
    % disp('offline start')
    fixie.errPrepareSetZero;
    
    nIter = domLengi * damLeng;
    % OFFLINE POD.
    % collect all reduced variables to perform POD.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 1);
        
        fixie.reducedVar(1);
        
        fixie.rvDisStore(iIter);
        
        fixie.pmPrepare(rvSVDswitch, 1);
        
        fixie.rvPrepare(rvSVDswitch);
        
        fixie.pmMultiRv;
        
        fixie.rvpmColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    fixie.rvSVD(rvSVDreRatio);
    
    fixie.impGenerate(1);
    
    fixie.respTdiffComputation(respSVDswitch, AbaqusSwitch, trialName, 1);
    
    fixie.respTimeShift(respSVDswitch);
    
    % CHANGE SIGN in this method!
    fixie.reshapeRespStore;
    
    fixie.uiTui;
    
    fixie.uiTujDamping;
    
    % disp('offline end')
    
    %% Greedy ONLINE.
    % disp('online start')
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 1);
        
        fixie.conditionalItplProdRvPm(iIter, rvSVDswitch);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
    % disp('online end')
    
    %% extract error information.
    fixie.errStoreSurfs('diff', 1);
    fixie.extractMaxErrorInfo('hats'); % greedy + 1
    disp({'Greedy iteration no' fixie.countGreedy})
    
    fixie.refiCondition('maxSurf', refCeaseSwitch);
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    fixie.extractMaxPmInfo('hhat', 1);
    
    if fixie.refinement.condition <= fixie.refinement.thres
        %% NO local h-refinement.
        fixie.greedyInfoDisplay('hhat');
        fixie.storeErrorInfo;
        fixie.errStoreAllSurfs('hhat');
        
        %         fixie.plotSurfGrid('hhat', 'b-.', 0);
        %         fixie.plotSurfGrid('hat', 'r--', 0);
        
        if fixie.countGreedy == drawRow * drawCol
            % put here to stop any uncessary computations.
            disp('iterations reach maximum plot number')
            break
        end
    
        fixie.exactSolutionDynamic('Greedy', AbaqusSwitch, trialName, 1);
        % rbEnrichment set the indicators.
        fixie.rbEnrichment(nPhiEnrich, reductionRatio, ratioSwitch, 'hhat', 1);
        fixie.reducedMatricesStatic;
        fixie.reducedMatricesDynamic;
        
        
    elseif fixie.refinement.condition > fixie.refinement.thres
        %% local h-refinement.
        % this method displays refinement informations.
        fixie.localHrefinement;
        
        fixie.respfromFce(respSVDswitch, AbaqusSwitch, trialName);
        
    end
    
end

%% verification by computing e(\mu) = U(\mu) - \bPhi\alpha(\mu).
% All Greedy iterations are included here.
fixie.verifyPrepare;
for iGre = 1:fixie.countGreedy
    fixie.verifyExtractBasis(iGre);
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 0);
        fixie.exactSolutionDynamic('verify', AbaqusSwitch, trialName, 0);
        fixie.verifyExactError(iGre, iIter);
        CmdWinTool('statusText', ...
            sprintf('verification stage progress: %d of %d', iIter, nIter));
        
    end
    fixie.verifyExtractMaxErr(iGre);
    fixie.verifyPlotSurf(iGre, 'r-^');
end

%%
fixie.plotMaxErrorDecayVal('verify', 'b-*', 2, 0);
fixie.plotMaxErrorDecayLoc('verify', 'b-*', 2, 0);