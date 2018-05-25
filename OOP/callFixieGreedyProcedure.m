clear; clc; clf
trialName = 'l9h2SingleInc';
typeSwitch = 'original';
rvSVDswitch = 0;
callPreliminary;

%% trial solution
% use subclass: fixbeam to create beam.
fixie = fixbeam(abaInpFile, mas, dam, sti, locStartCons, locEndCons, ...
    INPname, domLengi, domBondi, domMid, trial, noIncl, noStruct, ...
    noMas, noDam, tMax, tStep, errLowBond, errMaxValInit, ...
    errRbCtrl, errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, ...
    drawRow, drawCol, fNode, ftime, fRange, nConsEnd);

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

% generate nodal force.
fixie.generateNodalFceStatic(nDofPerNode);

% quantity of interest.
fixie.qoiSpaceTime(qoiSwitchSpace, 0);

% compute initial exact solution.
fixie.exactSolutionStatic('initial');

% compute initial reduced basis from trial solution. 
fixie.errPrepareRemainStatic;
fixie.rbInitialStatic;
disp(fixie.countGreedy)
fixie.reducedMatricesStatic;
while fixie.err.max.val > fixie.err.lowBond
    %% ONLINE
    fixie.errPrepareSetZeroOriginal;
    
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.reducedVarStatic;
        
        fixie.residualfromForceStatic;
        
        fixie.errStoreSurfs(typeSwitch);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
       
    fixie.extractMaxErrorInfo(typeSwitch, randomSwitch);
    fixie.extractMaxPmInfo(typeSwitch);
    
    fixie.greedyInfoDisplay('original');
    fixie.storeErrorInfoOriginal;
    
    fixie.errStoreAllSurfs('original');
    
    figure(1)
    fixie.plotSurfGrid(drawRow, drawCol, 1, typeSwitch, 'b');
    
    fixie.exactSolutionStatic('Greedy');
    % rbEnrichment set the indicators.
    fixie.rbEnrichmentStatic;
    fixie.reducedMatricesStatic;
    
    if fixie.countGreedy > drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    disp(fixie.countGreedy)
    
end