clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
% route = '/Users/kevin/Documents/Temp';

oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'l2h1';
lin = 1;
[INPname, mas, sti1, sti2, stis, locStart, locEnd] = ...
    trialCaseSelection(trialName, lin);
noIncl = 3;
dam = 0;

%% data for parameter class.
domLeng1 = 5;
domLeng2 = 5;
domLengs = 5;
bondL1 = 1;
bondR1 = 2;
bondL2 = 1;
bondR2 = 2;
nIter = domLeng1 * domLeng2;
% mid 1 and 2 are used for refinement, middle points are needed for the
% initial refinements.
mid1 = (bondL1 + bondR1) / 2;
mid2 = (bondL2 + bondR2) / 2;

%% data for time
tMax = 0.03;
tStep = 0.01;

%% data for external nodal force.
% fNode needs to be manually updated.
fNode = 4;
ftime = 0.02;

%% parameter data for trial iteration.
trial = [1, 1];

%% error informations
errLowBond = 1e-12;
errMaxValInit = 1;
errRbCtrl = 1;
errRbCtrlThres = 0.01;
errRbCtrlTNo = 1;

%% counter
cntInit = 1;

%% refinement threshold.
refiThres = 0.01;

%% plot surfaces and grids
drawRow = 2;
drawCol = 3;

viewX = -30;
viewY = 30;
gridSwitch = 0;

%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti1, sti2, stis, locStart, locEnd, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxValInit, errRbCtrl, ...
    errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres, drawRow, drawCol, ...
    fNode, ftime);

% read constraint infomation, 2 = 2d.
canti.readINPcons(2);

% read geometric information.
canti.readINPgeo;

% generate parameter space.
canti.generatePmSpace;

% read mass matrix, 2 = 2d.
canti.readMTX2DOF(2);

% read stiffness matrices, 2 = 2d.
canti.readMTX2DOFBCMod(2);

% extract parameter infomation for trial point.
canti.pmTrial;

% sum affined terms with trial parameter combination.
canti.trialSti(canti.pmVal.I1.trial, canti.pmVal.I2.trial, canti.pmVal.s.fix);

% initialise damping, velocity, displacement input.
canti.damMtx;
canti.velInpt;
canti.disInpt;

% generate nodal force.
canti.generateNodalFce(2);

% compute trial solution
canti.sti.full = canti.sti.trial;
canti.fce.pass = canti.fce.val;
canti.NewmarkBetaReducedMethodOOP('full');
canti.dis.trial = canti.dis.full;
canti.dis.trialSumsqr = sumsqr(canti.dis.trial);
canti.rbSingleInitial(1);
% compute initial reduced basis from trial solution.
canti.approSolution('initial');

%% main while loop
canti.initHatPm;

canti.gridtoBlockwithIndx('beamClass');

canti.refineGridLocalwithIdx('initial');

timeType = 'allTime';
svdType = 'noSVD';

canti.Setup(svdType);

refindicator = 0;

canti.respStorePmPrepare(timeType);

canti.no.respSVD = 1;
% exact solutions when Greedy iteration = 1.
canti.respImpFce(canti.no.respSVD, svdType);

while canti.err.max.val.slct > canti.err.lowBond
    
    %% OFFLINE
    disp('offline start')
    
    canti.impPrepare;
    
    switch timeType
        
        case 'allTime'
            for i_pre = 1:canti.no.pre.hhat
                
                for i_phy = 1:canti.no.phy
                    
                    canti.impInitStep(canti.no.rb, i_phy);
                    
                    canti.respImpAllTime(i_pre, canti.no.rb, i_phy);
                    
                end
                
            end
            
        case 'partTime'
            for i_pre = 1:canti.no.pre.hhat
                
                canti.respImpFce(i_pre, canti.no.respSVD, svdType);
                
                for i_phy = 1:canti.no.phy
                    
                    canti.impInitStep(canti.no.rb, i_phy);
                    
                    switch svdType
                        case 'noSVD'
                            canti.respImpPartTime(i_pre, i_phy, canti.no.rb);
                            
                        case 'SVD'
                            canti.respImpPartTimeSVD...
                                (i_pre, i_phy, canti.no.rb, canti.no.respSVD);
                            
                    end
                end
            end
            
    end
    
    % extract all responses.
    %     canti.preSelectResptoItpl(timeType);
    
    % extract displacement only. CHANGE SIGN here!
    canti.preSelectDistoItpl(timeType);
    
    disp('offline end')
    %% ONLINE
    canti.err.store.surf.errwRb = zeros(canti.domLeng.I1, canti.domLeng.I2);
    
    disp('online start')
    for i_iter = 1:nIter
        %     for i_iter = 3
        canti.reducedVar(i_iter);
        
        nBlkhh = length(canti.pmExpo.block.hhat);
        canti.inpolyItpl(nBlkhh, canti.pmExpo.block.hhat, 'hhat', 0, timeType);
        
        canti.resp.itpl.hhat = canti.resp.itpl.otpt;
        
        if canti.no.block.hat == 1
            % no refinement at all, ehat needs to be interpolated.
            nBlkh = length(canti.pmExpo.block.hat);
            canti.inpolyItpl(nBlkh, canti.pmExpo.block.hat, 'hat', 0, timeType);
            canti.resp.itpl.hat = canti.resp.itpl.otpt;
            
        elseif canti.no.block.hat > 1
            % when there is a refinement, only interpolate the refined block.
            canti.errItplIndicator;
            
            if any(canti.err.itpl.indicator) == 1
                % if pm point is in refined block, interpolate.
                
                canti.inpolyItpl(4, canti.pmExpo.block.add, 'add', 0, timeType);
                canti.resp.itpl.hat = canti.resp.itpl.otpt;
                
            elseif any(canti.err.itpl.indicator) == 0
                % if pm point is not in refined block, hat = hhat.
                canti.resp.itpl.hat = canti.resp.itpl.hhat;
            end
        end
        
        canti.respMultiplyPmRvSum(timeType, i_iter);
        
        canti.exactErrwithRB; %
        canti.errStoreSurfs(i_iter, 'errwRb');
        CmdWinTool('statusText', sprintf('Progress: %d of %d', i_iter, nIter));
        
    end
    
    canti.resptoErrStore;
    break
    canti.extractErrorInfo('hats');
    canti.extractErrorInfo('errwRb');
    
    disp('online end')
    
    refiCond = abs((canti.err.max.val.hhat - ...
        canti.err.max.val.hat) / canti.err.max.val.hhat);
    
    canti.extractPmInfo(canti.err.max.loc.hat, canti.err.max.loc.hat);
    
    %% local h-refinement.
    if refiCond <= canti.refinement.thres
        refindicator = 0;
        
        canti.storeErrorInfo('errwRb'); % exact error with new rb. %
        canti.storeErrorInfo('hats');
        disp(canti.countIter)
        if canti.countIter == 1
            axisLim = canti.err.max.val.errwRb;
        end
        
        figure(2)
        canti.err.max.pass = canti.err.max.val.hat;
        canti.err.store.pass = canti.err.store.surf.hat;
        canti.plotSurfGrid(drawRow, drawCol, viewX, viewY, gridSwitch, axisLim);
        if canti.countIter >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        
        canti.countIter = canti.countIter + 1;
        
        canti.rbEnrichment;
        
        canti.approSolution('iter');
        
    elseif refiCond > canti.refinement.thres
        
        refindicator = 1;
        
        % only compute exact solutions regarding external force
        % when pm domain is refined.
        canti.respImpFce(i_pre, canti.no.respSVD, svdType);
        
        disp(strcat('refinement condition', {' = '}, num2str(refiCond)))
        disp('h-refinement')
        canti.localHrefinement;
        
    end
end


