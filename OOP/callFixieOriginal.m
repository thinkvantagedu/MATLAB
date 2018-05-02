clear; clc; clf;
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

% compute initial reduced basis from trial solution. There are different
% approaches.
fixie.rbInitial(nPhiInitial, reductionRatio, singularSwitch);
% fixie.rbCtrlInitial(rbCtrlThres);
% fixie.rbReVarInitial(reductionRatio);
disp(fixie.countGreedy)
fixie.reducedMatrices;
fixie.errPrepareRemainOriginal;

while fixie.err.max.val > fixie.err.lowBond
    %% ONLINE
    fixie.errPrepareSetZeroOriginal;
    
    for iIter = 1:nIter
        
        fixie.pmIter(iIter);
        
        fixie.reducedVar;
        
        fixie.residualfromForce...
            ('fro', qoiSwitchSpace, qoiSwitchTime, AbaqusSwitch, trialName);
        
        fixie.errStoreSurfs(typeSwitch);
        
        CmdWinTool('statusText', sprintf('Progress: %d of %d', iIter, nIter));
        
    end
       
    fixie.extractMaxErrorInfo(typeSwitch, randomSwitch);
    fixie.extractMaxPmInfo(typeSwitch);
    fixie.storeErrorInfoOriginal;
    
    fixie.errStoreAllSurfs('original');
    
    figure(1)
    fixie.plotSurfGrid(drawRow, drawCol, 1, typeSwitch, '-.k');
    
    fixie.greedyInfoDisplay(typeSwitch);
    if fixie.countGreedy >= drawRow * drawCol
        disp('iterations reach maximum plot number')
        break
    end
    
    fixie.exactSolution('Greedy', qoiSwitchTime, qoiSwitchSpace, AbaqusSwitch);
    
    fixie.rbEnrichment(nPhiEnrich, reductionRatio, singularSwitch, ratioSwitch);
    fixie.reducedMatrices;
    disp(fixie.countGreedy)
    
end
%%
% figure(2)
% fixie.plotMaxErrorDecayVal('original', 'k-*', 2, nPhiInitial);
% figure(3)
% fixie.plotMaxErrorDecayLoc('original', 'k-*', 2);