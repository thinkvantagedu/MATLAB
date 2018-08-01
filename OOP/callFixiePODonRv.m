% this is the implemented callFixie without damping.
clear; clc; clf;
trialName = 'l9h2SingleInc';
rvSVDswitch = 1;
callPreliminary;
noPm = 1;
nConsEnd = 2;
nDofPerNode = 2;
fNode = 9;

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
fixie.generatePmSpaceSingleDim(randomSwitch, structSwitch, sobolSwitch, ...
    haltonSwitch, latinSwitch);

% read stiffness matrices.
fixie.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial(0);

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
% set up refined initial samples, nhhat = 5 and nhat = 3.
refSwitch = 1;
if refSwitch == 1
    uiTujSwitch = 0;
    disp('initial sample set is refined')
    fixie.refinedInit;
end
% prepare essential storage for error and responses.
fixie.otherPrepare(nRespSVD);
fixie.errPrepareRemainProp;

% compute initial exact solution.
fixie.exactSolutionDynamic('initial', AbaqusSwitch, trialName, 0);

% compute initial reduced basis from trial solution.
fixie.rbInitialDynamic(nPhiInitial, reductionRatio, ratioSwitch, 'hhat', 0);
fixie.reducedMatricesStatic;
fixie.reducedMatricesDynamic;

fixie.impPrepareRemain;
fixie.respStorePrepareRemain(timeType);

% initial computation of force responses.
fixie.respfromFce(respSVDswitch, AbaqusSwitch, trialName, 0);

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
    
    % OFFLINE POD.
    % collect all reduced variables to perform POD.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 0);
        
        fixie.reducedVar(0);
        
        fixie.rvDisStore(iIter);
        
        fixie.pmPrepare(rvSVDswitch, 0);
        
        fixie.rvPrepare(rvSVDswitch);
        
        fixie.rvpmColStore(iIter);
        
    end
    
    % SVD on the collected reduced variables.
    fixie.rvSVD(rvSVDreRatio);
    
    fixie.impGenerate(0);
    
    fixie.respTdiffComputation(respSVDswitch, AbaqusSwitch, trialName, 0);
    
    fixie.respTimeShift(respSVDswitch);
    
    % CHANGE SIGN in this method!
    fixie.reshapeRespStore;
    
    fixie.uiTui;
    
    if uiTujSwitch == 1
        % shut off uiTuj to increase speed.
        fixie.uiTuj;
    end
    
    % disp('offline end')
    
    %% Greedy ONLINE.
    % disp('online start')
    % multiply the output with pm and interpolate.
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 0);
        
        fixie.conditionalItplProdRvPm(iIter, rvSVDswitch, 0, uiTujSwitch);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
    % disp('online end')
    
    %% extract error information.
    fixie.errStoreSurfs('diff', 0);
    fixie.extractMaxErrorInfo('hats', 0, 0, 0, 0, 0, 0); % greedy + 1
    disp({'Greedy iteration no' fixie.countGreedy})
    
    fixie.refiCondition('maxSurf', refCeaseSwitch);
    % this line extracts parameter values of maximum error and
    % corresponding location. Change input accordingly.
    % pm1 decides location of maximum error; pm2 decides PM value of maximum
    % error, not value of maximum error.
    fixie.extractMaxPmInfo('hhat');
    
    if fixie.refinement.condition <= fixie.refinement.thres
        %% NO local h-refinement.
        fixie.storeErrorInfo;
        fixie.greedyInfoDisplay('hhat', 0);
        fixie.errStoreAllSurfs('hhat');
        %%
%         fixie.plotSurfGrid('hhat', 'k->', 0);
%         fixie.plotSurfGrid('hat', 'r-<', 0);
        %%
        if fixie.countGreedy == drawRow * drawCol
            % put here to stop any uncessary computations.
            disp('iterations reach maximum plot number')
            break
        end
        
        fixie.exactSolutionDynamic('Greedy', AbaqusSwitch, trialName, 0);
        % rbEnrichment set the indicators.
        fixie.rbEnrichmentDynamic(nPhiEnrich, reductionRatio, ratioSwitch, ...
            'hhat', 0, 0);
        fixie.reducedMatricesStatic;
        fixie.reducedMatricesDynamic;
        
    elseif fixie.refinement.condition > fixie.refinement.thres
        %% local h-refinement.
        % this method displays refinement informations.
        fixie.localHrefinement;
        
        fixie.respfromFce(respSVDswitch, AbaqusSwitch, trialName, 0);
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
%     fixie.verifyPlotSurf(iGre, 'b-^');
    
end
% legend({'$\hat{\hat{e}}$ (slave)', '$\hat{e}$ (master)', ...
%     '$e$ (classical)'}, ...
%     'Interpreter','latex', 'FontSize', 20)

%%
% fixie.plotMaxErrorDecayVal('verify', 'b-*', 2, 0);
% fixie.plotMaxErrorDecayLoc('verify', 'b-*', 2, 0);