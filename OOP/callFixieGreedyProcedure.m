% this is the original static case, no damping, to test the Greedy procedure.

clear; clc;
trialName = 'l9h2SingleInc';
rvSVDswitch = 0;
callPreliminary;
noPm = 1;

%% trial solution
% use subclass: fixbeam to create beam.
fixie = fixbeam(abaInpFile, mas, dam, sti, locStartCons, locEndCons, ...
    INPname, domLengi, domBondi, domMid, trial, noIncl, noStruct, noPm, ...
    noMas, noDam, tMax, tStep, errLowBond, errMaxValInit, ...
    errRbCtrl, errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
    drawRow, drawCol, fNode, ftime, fRange, nConsEnd);

% read constraint infomation.
fixie.readINPconsFixie(nDofPerNode);

% read geometric information.
fixie.readINPgeoMultiInc;

% generate parameter space.
fixie.generatePmSpaceSingleDim;

% read stiffness matrices.
fixie.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial(0);

% generate nodal force.
fixie.generateNodalFceStatic(nDofPerNode);

% quantity of interest.
fixie.qoiSpaceTime(qoiSwitchSpace, 0);

% compute initial exact solution.
fixie.exactSolutionStatic('initial');
fixie.errPrepareRemainStatic;

% compute initial reduced basis from trial solution. 
fixie.rbInitialStatic;
fixie.reducedMatricesStatic;
while fixie.err.max.val > fixie.err.lowBond
    
    if fixie.countGreedy == drawRow * drawCol
        % put here to stop any uncessary computations.
        disp('iterations reach maximum plot number')
        break
    end
    
    %% ONLINE
    fixie.errPrepareSetZeroOriginal;
    
    for iIter = 1:nIter
        
        fixie.pmIter(iIter, 0);
        
        fixie.reducedVarStatic;
        
        fixie.residualfromForceStatic;
        
        fixie.errStoreSurfs('original', 0);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
       
    fixie.extractMaxErrorInfo('original', randomSwitch, 0); % greedy + 1
    disp({'Greedy iteration no' fixie.countGreedy})
    
    fixie.extractMaxPmInfo('original', 0);
    fixie.greedyInfoDisplay('original');
    fixie.storeErrorInfoOriginal;
    fixie.errStoreAllSurfs('original');
    
%     fixie.plotSurfGrid('original', 'b', 0);
    
    if fixie.countGreedy == drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    
    fixie.exactSolutionStatic('Greedy');
    % rbEnrichment set the indicators.
    fixie.rbEnrichmentStatic;
    fixie.reducedMatricesStatic;
    
end