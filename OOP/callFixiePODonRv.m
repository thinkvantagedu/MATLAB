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
fixie.qoiSpaceTime(nQoiT, nDofPerNode, qoiSwitchManual);

% initialise interpolation samples.
fixie.initHatPm;
fixie.refineGridLocalwithIdx('initial');
% prepare essential storage for error and responses.
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemainProp;

% compute initial exact solution.
fixie.exactSolution('initial', qoiSwitchTime, qoiSwitchSpace, ...
    AbaqusSwitch, trialName);

% compute initial reduced basis from trial solution.
fixie.rbInitial(nPhiInitial, reductionRatio, singularSwitch, ratioSwitch);
disp(fixie.countGreedy)
fixie.reducedMatrices;

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
    
    fixie.respTimeShift(qoiSwitchTime, qoiSwitchSpace, respSVDswitch);
    
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
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
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
        figure(1)
        fixie.plotSurfGrid(drawRow, drawCol, 1, 'hhat', 'b--');
        %         fixie.plotSurfGrid(drawRow, drawCol, 1, 'hat', 'm-.');
        
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
        % this method displays refinement informations.
        fixie.localHrefinement;
        
        fixie.respfromFce(respSVDswitch, qoiSwitchTime, qoiSwitchSpace, ...
            AbaqusSwitch, trialName);
        
    end
    
end

%%
% figure(2)
% hold on
% fixie.plotMaxErrorDecayVal('hhat', 'b-*', 2, nPhiInitial);
% figure(3)
% hold on
% fixie.plotMaxErrorDecayLoc('hhat', 'b-*', 2);