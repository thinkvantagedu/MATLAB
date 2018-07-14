% this is the original static case, no damping, to test the Greedy procedure.
% initial sample is 10^0, to suit the uniform structure sequence.
clear; clc; clf;
trialName = 'l9h2SingleInc';
rvSVDswitch = 0;
callPreliminary;
noPm = 1;
nConsEnd = 2;
nDofPerNode = 2;
fNode = 9;

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
fixie.generatePmSpaceSingleDim(randomSwitch, structSwitch, sobolSwitch, ...
    haltonSwitch, latinSwitch);

% read stiffness matrices.
fixie.readStiMTX2DOFBCMod(nDofPerNode);

% extract parameter infomation for trial point.
fixie.pmTrial(0);

% generate nodal force.
fixie.generateNodalFceStatic(nDofPerNode);

% quantity of interest. Time is not varied in this case. 
fixie.qoiSpaceTime(qoiSwitchSpace, 0);
fixie.errPrepareRemainStatic;
if any([greedySwitch randomSwitch sobolSwitch latinSwitch haltonSwitch]) == 1
    % compute initial exact solution.
    % the exact solution is computed for SINGLE magic point.
    fixie.exactSolutionStatic('initial');
elseif structSwitch == 1
    % the exact solutions are computed for ALL magic points.
    fixie.exactSolutionStructStatic('initial');
end
% compute initial reduced basis from trial solution.
fixie.rbInitialStatic;
fixie.reducedMatricesStatic;
while fixie.err.max.realVal > fixie.err.lowBond
    
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
    
    fixie.extractMaxErrorInfo('original', greedySwitch, randomSwitch, ...
        sobolSwitch, haltonSwitch, latinSwitch, 0); % greedy + 1
    disp({'Greedy iteration no' fixie.countGreedy})
    
    fixie.extractMaxPmInfo('original');
    fixie.greedyInfoDisplay('original');
    fixie.storeErrorInfoOriginal;
    fixie.errStoreAllSurfs('original');
    
    fixie.plotSurfGrid('original', 'b', 0);
    
    if fixie.countGreedy == drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    if any([greedySwitch randomSwitch sobolSwitch ...
            latinSwitch haltonSwitch]) == 1
        % compute initial exact solution.
        % the exact solution is computed for SINGLE magic point.
        fixie.exactSolutionStatic('Greedy');
        % rbEnrichment set the indicators.
        fixie.rbEnrichmentStatic;
    else
        fixie.exactSolutionStructStatic('Greedy');
        fixie.rbEnrichmentStructStatic;
    end
    fixie.reducedMatricesStatic;
    
end