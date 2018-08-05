% this is the original callONERA_M6 with damping.
% 
clear; clc;
trialName = 'ONERA_M6_3683nodes';
rvSVDswitch = 0;
callPreliminary;
noPm = 2;
nConsEnd = 1;
nDofPerNode = 3;
fNode = 15;
tic
%% trial solution
% use subclass: fixbeam to create beam.
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
canti.qoiSpaceTime(qoiSwitchSpace, qoiSwitchTime);
canti.errPrepareRemainOriginal;

% compute initial exact solution.
canti.exactSolutionDynamic('initial', AbaqusSwitch, trialName, 1);

% compute initial reduced basis from trial solution. There are different
% approaches.
canti.rbInitialDynamic(nPhiInitial, reductionRatio, ratioSwitch, 'original', 1);
canti.reducedMatricesStatic;
canti.reducedMatricesDynamic;

while canti.err.max.realVal > canti.err.lowBond
    
    if canti.countGreedy == drawRow * drawCol
        % put here to stop any uncessary computations.
        disp('iterations reach maximum plot number')
        break
    end
    
    %% ONLINE
    canti.errPrepareSetZeroOriginal;
    
    nIter = domLengi * damLeng;
    for iIter = 1:nIter
        
        canti.pmIter(iIter, 1);
        
        canti.reducedVar(1);
        
        canti.residualfromForce(AbaqusSwitch, trialName, 1);
        
        canti.errStoreSurfs('original', 1);
        
        CmdWinTool('statusText', ...
            sprintf('Greedy Online stage progress: %d of %d', iIter, nIter));
        
    end
    
    canti.extractMaxErrorInfo('original', greedySwitch, randomSwitch,...
        sobolSwitch, haltonSwitch, latinSwitch, 1); % greedy + 1
    disp({'Greedy iteration no' canti.countGreedy})
    
    canti.extractMaxPmInfo('original');    
    canti.greedyInfoDisplay('original', structSwitch);
    canti.storeErrorInfoOriginal;
    canti.errStoreAllSurfs('original');
    
    canti.plotSurfGrid('original', '-.k', 1);
    
    if canti.countGreedy == drawRow * drawCol
        % put here to stop any uncessary computations.
        disp('iterations reach maximum plot number')
        break
    end
    
    canti.exactSolutionDynamic('Greedy', AbaqusSwitch, trialName, 1);
    % rbEnrichment set the indicators.
    canti.rbEnrichmentDynamic(nPhiEnrich, reductionRatio, ratioSwitch, ...
        'original', 1, structSwitch);
    canti.reducedMatricesStatic;
    canti.reducedMatricesDynamic;
    
end
toc
%%
if randomSwitch == 0
    lineWidth = 2;
    lineColor = 'b-*';
elseif randomSwitch == 1
    lineWidth = 1;
    lineColor = 'k--';
end

canti.plotMaxErrorDecayVal('original', lineColor, lineWidth, randomSwitch);
canti.plotMaxErrorDecayLoc('original', lineColor, lineWidth, 1);