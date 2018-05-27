% this is the implemented callFixie without damping.

clear; clc;
trialName = 'l9h2SingleInc';
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
fixie.qoiSpaceTime(qoiSwitchSpace, qoiSwitchTime);

% initialise interpolation samples.
fixie.initHatPm;
fixie.refineGridLocalwithIdx('initial');
% prepare essential storage for error and responses.
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemainProp;

% compute initial exact solution.
fixie.exactSolution('initial', AbaqusSwitch, trialName);

% compute initial reduced basis from trial solution.
fixie.rbInitial(nPhiInitial, reductionRatio, singularSwitch, ...
    ratioSwitch, 'hhat');
disp(fixie.countGreedy)
fixie.reducedMatricesStatic;
fixie.reducedMatricesDynamic;

fixie.impPrepareRemain;
fixie.respStorePrepareRemain(timeType);

% initial computation of force responses.
fixie.respfromFce(respSVDswitch, AbaqusSwitch, trialName);

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
        
        fixie.rvDisStore(iIter);
        
        fixie.pmPrepare(rvSVDswitch);
        
        fixie.rvPrepare(rvSVDswitch);
        
        fixie.pmMultiRv;
        
        fixie.rvpmColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    fixie.rvSVD(rvSVDreRatio);
    
    fixie.impGenerate;
    
    fixie.respTdiffComputation(respSVDswitch, AbaqusSwitch, trialName);
    
    fixie.respTimeShift(respSVDswitch);
    
    % CHANGE SIGN in this method!
    fixie.reshapeRespStore;
    
    fixie.uiTui;
    
    fixie.uiTuj;
    
    % disp('offline end')
    
    %% ONLINE.
    % disp('online start')
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.conditionalItplProdRvPm(iIter, rvSVDswitch);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
    % disp('online end')
    
    %% extract error information.
    fixie.errStoreSurfs('diff');
    fixie.extractMaxErrorInfo('hats');
    fixie.refiCondition('maxSurf', refCeaseSwitch);
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    fixie.extractMaxPmInfo('hhat');
    
    if fixie.refinement.condition <= fixie.refinement.thres
        %% NO local h-refinement.
        fixie.greedyInfoDisplay('hhat');
        fixie.storeErrorInfo;
        fixie.errStoreAllSurfs('hhat');
        
%         figure(1)
%         fixie.plotSurfGrid(drawRow, drawCol, 1, 'hhat', 'b-.');
%         fixie.plotSurfGrid(drawRow, drawCol, 1, 'hat', 'r--');
        
        fixie.exactSolution('Greedy', AbaqusSwitch);
        % rbEnrichment set the indicators.
        fixie.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ...
            ratioSwitch, 'hhat');
        fixie.reducedMatricesStatic;
        fixie.reducedMatricesDynamic;
        
        if fixie.countGreedy > drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        disp(fixie.countGreedy)
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
% figure(1)
for iGre = 1:fixie.countGreedy - 1
    fixie.verifyExtractBasis(iGre);
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        fixie.exactSolution('verify', 0);
        fixie.verifyExactError(iGre, iIter);
        CmdWinTool('statusText', ...
            sprintf('verification stage progress: %d of %d', iIter, nIter));
        
    end
    fixie.verifyExtractMaxErr(iGre);
%     fixie.verifyPlotSurf(iGre, 'r-^');
end

%%
figure(2)
fixie.plotMaxErrorDecayVal('verify', 'b-*', 2, 0);
figure(3)
fixie.plotMaxErrorDecayLoc('verify', 'b-*', 2);