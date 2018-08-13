% this is the implemented callONERA_M6 with damping.

clear; clc;
trialName = 'Ibeam_8295nodes';
% trialName = 'Ibeam_3146nodes';
rvSVDswitch = 1;
callPreliminary;
noPm = 2;
nConsEnd = 1;
nDofPerNode = 3;
fNode = 22;
tic
%% trial solution.
% use subclass: canbeam to create beam.
canti = canbeam(abaInpFile, mas, dam, sti, locStartCons, locEndCons, ...
    INPname, domLengi, domBondi, domMid, trial, noIncl, noStruct, noPm, ...
    noMas, noDam, tMax, tStep, errLowBond, errMaxValInit, ...
    errRbCtrl, errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
    drawRow, drawCol, fNode, ftime, fRange, nConsEnd);

% read mass matrix.
canti.readMasMTX2DOF(nDofPerNode);

% read constraint infomation.
canti.readINPconsCanti(nDofPerNode);

% read geometric information.
canti.readINPgeoMultiInc(nDofPerNode);

% generate parameter space.
canti.generatePmSpaceSingleDim(randomSwitch, structSwitch, sobolSwitch, ...
    haltonSwitch, latinSwitch);

% generate damping coefficient space, the combination is stiffness then damping.
canti.generateDampingSpace(damLeng, damBond, randomSwitch, sobolSwitch, ...
    haltonSwitch, latinSwitch);

% read stiffness matrices.
canti.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
canti.pmTrial(1);

% initialise damping, velocity, displacement input.
canti.damMtx;
canti.velInpt;
canti.disInpt;

% generate nodal force.
canti.generateNodalFce(nDofPerNode, 0.3, debugMode);

% quantity of interest.
canti.qoiSpaceTime(qoiSwitchSpace, qoiSwitchTime, nDofPerNode);

% initialise interpolation samples.
canti.initHatPm;
canti.refineGridLocalwithIdx('initial');

% prepare essential storage for error and responses.
canti.otherPrepare(nRespSVD);
canti.errPrepareRemainProp;

% compute initial exact solution.
canti.exactSolutionDynamic('initial', AbaqusSwitch, trialName, 1);

% compute initial reduced basis from trial solution.
canti.rbInitialDynamic(nPhiInitial, reductionRatio, ratioSwitch, 'hhat', 1);
canti.reducedMatricesStatic;
canti.reducedMatricesDynamic;

canti.impPrepareRemain;
canti.respStorePrepareRemain(timeType);

% initial computation of force responses.
canti.respfromFce(respSVDswitch, AbaqusSwitch, trialName, 1);

%% main while loop.
while canti.err.max.val.hhat > canti.err.lowBond
    if canti.countGreedy == drawRow * drawCol
        % put here to stop any uncessary computations.
        disp('iterations reach maximum plot number')
        break
    end
    %% Greedy OFFLINE.
    %     disp('POD-Greedy offline start')
    canti.errPrepareSetZero;
    
    nIter = domLengi * damLeng;
    % OFFLINE POD.
    % collect all reduced variables to perform POD.
    for iIter = 1:nIter
        
        canti.pmIter(iIter, 1);
        
        canti.reducedVar(1);
        
        canti.rvDisStore(iIter);
        
        canti.pmPrepare(rvSVDswitch, 1);
        
        canti.rvPrepare(rvSVDswitch);
        
        canti.rvpmColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    canti.rvSVD(rvSVDreRatio);
    % with damping,  impulse doesn't * coeff, this is sorted in pmPrepare.
    canti.impGenerate(1);
    
    canti.respTdiffComputation(respSVDswitch, AbaqusSwitch, trialName, 1);
    
    canti.respTimeShift(respSVDswitch);
    
    % CHANGE SIGN in this method!
    canti.reshapeRespStore;
    
    canti.uiTui;
    
    if uiTujSwitch == 1
        % shut off uiTuj to increase speed.
        canti.uiTujDamping;
    end
    %     disp('POD-Greedy offline end')
    
    %% Greedy ONLINE.
    %     disp('POD-Greedy online start')
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        canti.pmIter(iIter, 1);
        
        canti.conditionalItplProdRvPm(iIter, rvSVDswitch, 1, uiTujSwitch);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
    %     disp('POD-Greedy online end')
    
    %% extract error information.
    canti.errStoreSurfs('diff', 1);
    canti.extractMaxErrorInfo('hats', 0, 0, 0, 0, 0, 1); % greedy + 1
    disp({'Greedy iteration no' canti.countGreedy})
    
    canti.refiCondition('maxSurf', refCeaseSwitch);
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    canti.extractMaxPmInfo('hhat');
    
    if canti.refinement.condition <= canti.refinement.thres
        %% NO local h-refinement.
        canti.greedyInfoDisplay('hhat', 0);
        canti.storeErrorInfo;
        canti.errStoreAllSurfs('hhat');
        
        canti.plotSurfGrid('hhat', 'b-.', 1);
%         canti.plotSurfGrid('hat', 'r--', 1);
        
        if canti.countGreedy == drawRow * drawCol
            % put here to stop any uncessary computations.
            disp('iterations reach maximum plot number')
            break
        end
        
        canti.exactSolutionDynamic('Greedy', AbaqusSwitch, trialName, 1);
        % rbEnrichment set the indicators.
        canti.rbEnrichmentDynamic(nPhiEnrich, reductionRatio, ratioSwitch, ...
            'hhat', 1, 0);
        canti.reducedMatricesStatic;
        canti.reducedMatricesDynamic;
        
    elseif canti.refinement.condition > canti.refinement.thres
        %% local h-refinement.
        % this method displays refinement informations.
        canti.localHrefinement;
        
        canti.respfromFce(respSVDswitch, AbaqusSwitch, trialName, 1);
        
    end
    
end
toc
% %% verification by computing e(\mu) = U(\mu) - \bPhi\alpha(\mu).
% % All Greedy iterations are included here.
% canti.verifyPrepare;
% for iGre = 1:canti.countGreedy
%     canti.verifyExtractBasis(iGre);
%     for iIter = 1:nIter
% 
%         canti.pmIter(iIter, 1);
% 
%         canti.exactSolutionDynamic('verify', AbaqusSwitch, trialName, 1);
%         canti.verifyExactError(iGre, iIter);
%         CmdWinTool('statusText', ...
%             sprintf('verification stage progress: %d of %d', iIter, nIter));
% 
%     end
%     canti.verifyExtractMaxErr(iGre);
% %     canti.verifyPlotSurf(iGre, 'r-^');
% end

%
% canti.plotMaxErrorDecayVal('verify', 'b-*', 2, 0); % randomSwitch
% canti.plotMaxErrorDecayLoc('verify', 'b-*', 2, 1); % damSwitch