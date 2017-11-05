clear; clc;
tOffTime = 0;
route = '/home/xiaohan/Desktop/Temp';
figRoute = '/home/xiaohan/Desktop/Temp/numericalResults/';
oopPath = strcat(route, '/MATLAB/OOP');
addpath(genpath(oopPath));
%% data for beam class.
trialName = 'airfoilMedium';
lin = 1;
[INPname, mas, sti1, sti2, stis, locStart, locEnd] = ...
    trialCaseSelection(trialName, lin);
noIncl = 3;
dam = 0;

%% data for parameter class.
domLeng1 = 100;
domLeng2 = 100;
domLengs = 100;
bondL1 = 2;
bondR1 = 3;
bondL2 = 1;
bondR2 = 2;
% mid 1 and 2 are used for refinement, middle points are needed for the
% initial refinements.
mid1 = (bondL1 + bondR1) / 2;
mid2 = (bondL2 + bondR2) / 2;

%% data for time
tMax = 99;
tStep = 1;

%% data for external nodal force.
fTime = 1;
% fNode needs to be manually updated.
fNode = 16;
fPeriod = 1;
fAmp = 100;

%% parameter data for trial iteration.
trial = [1, 1];

%% error informations
errLowBond = 1e-8;
errMaxVal = 1;
errRbCtrl = 2;
errRbCtrlThres = 0.8;
errRbCtrlTNo = 1;

%% counter
cntInit = 1;

%% refinement
refiThres = 0.01;

%% plot surfaces and grids
drawRow = 2;
drawCol = 4;

viewX = -30;
viewY = 30;
gridSwitch = 1;

%% trial solution
% use subclass: canbeam to create cantilever beam.
canti = canbeam(mas, dam, sti1, sti2, stis, locStart, locEnd, INPname, ...
    domLeng1, domLeng2, domLengs, bondL1, bondR1, bondL2, bondR2, ...
    trial, noIncl, tMax, tStep, mid1, mid2, errLowBond, errMaxVal, errRbCtrl, ...
    errRbCtrlThres, errRbCtrlTNo, cntInit, refiThres,...
    fTime, fNode, fPeriod, fAmp);

% read constraint infomation.
canti.readINPcons(3);

% read geometric information.
canti.readINPgeo;

% generate parameter space.
canti.generatePmSpace;

% read mass matrix.
canti.readMTX2DOF(3);

% read stiffness matrices.
canti.readMTX2DOFBCMod(3);

% extract parameter infomation for trial point.
canti.pmTrial;

% sum affined terms with trial parameter combination.
canti.trialSti(canti.pmVal.I1.trial, canti.pmVal.I2.trial, canti.pmVal.s.fix);

% initialise damping, velocity, displacement input.
canti.damMtx;
canti.velInpt;
canti.disInpt;

% generate nodal force.
canti.generateNodalFce(3);

% compute trial solution

canti.sti.full = canti.sti.trial;
canti.fce.pass = canti.fce.val;
canti.NewmarkBetaReducedMethodOOP('full');
canti.dis.trial = canti.dis.full;
canti.dis.trialSumsqr = sumsqr(canti.dis.trial);

%% main while loop
canti.initHatPm;

canti.gridtoBlockwithIndx('beamClass');

canti.refineGridLocalwithIdx('initial');

canti.err.store.errwRb.max = [];
canti.err.store.hat.max = [];
canti.err.store.hhat.max = [];
canti.err.store.diff.max = [];
canti.err.store.errwRb.loc = [];
canti.err.store.hat.loc = [];
canti.err.store.hhat.loc = [];
canti.err.store.diff.loc = [];

errPreStore = cell(8, 1);

while canti.err.max.val > canti.err.lowBond
    
    if canti.countIter == 1
        
        canti.rbCtrlInitial(errRbCtrlThres);
        
        canti.approSolution('initial');
        
    elseif canti.countIter > 1 && refindicator == 0; % no h-refinement
        
        canti.rbEnrichment;
        
        canti.approSolution('iter');
        
    end
    
    %% OFFLINE
    canti.no.respSVD = 1;
    timeType = 'partTime';
    svdType = 'SVDimp';
    switch timeType
        
        case 'allTime'
            
            canti.respPrepare('allTime');
            
            for i_pre = 1:canti.no.pre.hhat
                % if SVD is not on-the-fly, see comment in respImpFce.
                canti.respImpFce(i_pre, canti.no.respSVD);
                
                for i_rb = 1:canti.no.rb
                    for i_phy = 1:canti.no.phy
                        
                        canti.respImpInitStep(i_rb, i_phy);
                        canti.respImpAllTime(i_pre, i_rb, i_phy);
                        
                    end
                end
            end
            
            switch svdType
                
                case 'noSVD'
                    canti.resptoErrPreCompAllTime;
                    
                case 'SVD'
                    canti.resptoErrPreCompSVDallTime;
                    
            end
            
            
        case 'partTime'
            
            canti.respPrepare('partTime');
            
            for i_pre = 1:canti.no.pre.hhat
                
                canti.respImpFce(i_pre, canti.no.respSVD);
                
                for i_rb  = 1:canti.no.rb
                    for i_phy = 1:canti.no.phy
                        
                        canti.respImpInitStep(i_rb, i_phy);
                        switch svdType
                            case 'noSVD'
                                canti.respImpPartTime(i_pre, i_rb, i_phy);
                            case {'SVD', 'SVDimp'}
                                canti.respImpPartTimeSVD...
                                    (i_pre, i_rb, i_phy, canti.no.respSVD);
                        end
                    end
                end
            end
            
            switch svdType
                
                case 'noSVD'
                    canti.resptoErrPreCompNoSVDpartTime;
%                     f = @() canti.resptoErrPreCompNoSVDpartTime;
%                     timeit(f)
                case 'SVD'
                    canti.resptoErrPreCompSVDpartTime;
                    
                case 'SVDimp'
                    canti.resptoErrPreCompSVDpartTimeImprovised;
%                     f = @() canti.resptoErrPreCompSVDpartTimeImprovised;
%                     timeit(f)
            end
            
    end
    
    canti.errStoretoCoefStore('hhat');
    canti.errStoretoCoefStore('hat');
    %% ONLINE
    canti.err.store.surf.hats = cell(2, 1);
    canti.err.store.surf.hats{1} = zeros(canti.domLeng.I1, canti.domLeng.I2);
    canti.err.store.surf.hats{2} = zeros(canti.domLeng.I1, canti.domLeng.I2);
    canti.err.store.surf.errwRb = zeros(canti.domLeng.I1, canti.domLeng.I2);
    
    for i_iter = 1:length(canti.pmVal.comb.space)
        
        canti.reducedVar(i_iter);
        
        canti.rvpm('rv');
        
        canti.rvpm('pm');
        
        nBlkhh = length(canti.pmExpo.block.hhat);
        canti.inpolyItplLag(nBlkhh, canti.pmExpo.block.hhat, canti.coef.hhat);
        canti.err.itpl.hhat = canti.err.itpl.otpt;
        
        if canti.no.block.hat == 1
            
            nBlkh = length(canti.pmExpo.block.hat);
            canti.inpolyItplLag(nBlkh, canti.pmExpo.block.hat, canti.coef.hat);
            canti.err.itpl.hat = canti.err.itpl.otpt;
            
        elseif canti.no.block.hat > 1
            
            canti.errItplIndicator;
            
            if any(canti.err.itpl.indicator) == 1
                
                canti.inpolyItplLag(4, canti.pmExpo.block.add, canti.coef.add);
                canti.err.itpl.hat = canti.err.itpl.otpt;
                
            elseif any(canti.err.itpl.indicator) == 0
                
                canti.err.itpl.hat = canti.err.itpl.hhat;
                
            end
        end
        canti.rvPmErrProdSum;
        
%         canti.exactErrwithRB; % exact error with new rb.
        
        canti.errStoreSurfs(i_iter, 'hats');
        canti.errStoreSurfs(i_iter, 'diff');
%         canti.errStoreSurfs(i_iter, 'errwRb');  % exact error with new rb.
        disp(i_iter)
    end
    
    %% extract error information
%     canti.extractErrorInfo(canti.err.store.surf.errwRb); %  exact error with new rb.
%     canti.err.max.errwRb = canti.err.max.valExt; %  exact error with new rb.
%     canti.err.maxLoc.errwRb = canti.err.max.loc; %  exact error with new rb.
%     canti.err.max.val = canti.err.max.errwRb; %  exact error with new rb.
    
    canti.extractErrorInfo(canti.err.store.surf.hats{1});
    canti.err.max.hat = canti.err.max.valExt;
    canti.err.maxLoc.hat = canti.err.max.loc;
    canti.err.max.val = canti.err.max.hat;
    
    canti.extractErrorInfo(canti.err.store.surf.hats{2});
    canti.err.max.hhat = canti.err.max.valExt;
    canti.err.maxLoc.hhat = canti.err.max.loc;
    
    canti.extractErrorInfo(canti.err.store.surf.diff);
    canti.err.max.diff = canti.err.max.valExt;
    canti.err.maxLoc.diff = canti.err.max.loc;
    
    refiCond = abs((canti.err.max.hhat - ...
        canti.err.max.hat) / canti.err.max.hhat);
    
    canti.extractPmInfo(canti.err.maxLoc.diff);
    
    %% local h-refinement.
    if refiCond <= canti.refinement.thres
        refindicator = 0;
        disp('no h-refinement');
        disp(strcat('refinement condition', {' = '}, num2str(refiCond)))
        
        disp(strcat('maximum error ', {' = '}, num2str(canti.err.max.val)))
%         canti.storeErrorInfo('errwRb'); %  exact error with new rb.
        canti.storeErrorInfo('hats');
        canti.storeErrorInfo('diff');
        
        if canti.countIter == 1
            axisLim = canti.err.max.val;
        end
        
        figure(1)
        canti.err.max.pass = canti.err.max.hat;
        canti.err.store.pass = canti.err.store.surf.diff;
        canti.plotSurfGrid(drawRow, drawCol, viewX, viewY, gridSwitch, axisLim);
        
        if canti.countIter >= drawRow * drawCol
            disp('iterations reach maximum plot number')
            break
        end
        errPreStore(canti.countIter) = canti.err.store.surf.hats(2);
        canti.countIter = canti.countIter + 1;
        
    elseif refiCond > canti.refinement.thres
        refindicator = 1;
        disp('h-refinement')
        canti.localHrefinement;
        
    end
    keyboard
end

figure(2)
canti.plotMaxErrorDecay(canti.err.store.hat.max);

figNameSurf = strcat(trialName, 'SVDallVec');
figPathSurf = strcat(figRoute, figNameSurf);
savefig(figPathSurf);

figNameDecay = strcat(trialName, 'SVDallVecDecay');
figPathDecay = strcat(figRoute, 'Decay/', figNameDecay);
savefig(figPathDecay);