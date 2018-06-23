clear; clc;
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

% read mass matrix. 
fixie.readMasMTX2DOF(nDofPerNode);

% read constraint infomation.
fixie.readINPconsFixie(nDofPerNode);

% read geometric information.
fixie.readINPgeoMultiInc;

% generate parameter space.
fixie.generatePmSpaceSingleDim(structSwitch, drawRow, drawCol);

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
fixie.errPrepareRemainOriginal;

% compute initial exact solution by Matlab.
fixie.exactSolutionDynamic('initial', 0, trialName, 0);
disMatlab = fixie.dis.trial;
% compute initial exact solution by Abaqus.
fixie.exactSolutionDynamic('initial', 1, trialName, 0);
disAbaqus = fixie.dis.trial;

%% plot displacement for test dof.
clf;
x = 1:fixie.no.t_step;

testDof = 500;
plot(x, disMatlab(testDof, :), 'b->');
hold on
plot(x, disAbaqus(testDof, :), 'k-<');