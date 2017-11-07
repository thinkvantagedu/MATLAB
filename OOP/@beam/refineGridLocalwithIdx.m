function obj = refineGridLocalwithIdx(obj, type)
% Refine locally, only refine the block which surround the pm_maxLoc.
% input is 4 by 2 matrix representing 4 corner coordinate (in a column way).
% output is 5 by 2 matrix representing the computed 5 midpoints.
% This function is able to compute any number of given blocks, not just one
% block.
% input is a matrix, output is also a matrix, not suitable for cell.
% input hat block and maximum point, output hhat points, hhat blocks.
% example: see testGSALocalRefiFunc.m

switch type
    
    case 'initial'
        
        pmEXPmax1 = obj.pmExpo.mid1;
        pmEXPmax2 = obj.pmExpo.mid2;
        
    case 'iteration'
        
        pmEXPmax1 = obj.pmExpo.max(1);
        pmEXPmax2 = obj.pmExpo.max(2);
        
end

pmExpInptPmTemp = cell2mat(obj.pmExpo.block.hat);
pmExpInptPm = pmExpInptPmTemp(:, 2:3);
pmEXPinptRaw = unique(pmExpInptPm, 'rows');
nBlk = length(obj.pmExpo.block.hat);
% find which block max pm point is in, refine.

for iBlk = 1:nBlk
    
    if inpolygon(pmEXPmax1, pmEXPmax2, ...
            obj.pmExpo.block.hat{iBlk}(:, 2), ...
            obj.pmExpo.block.hat{iBlk}(:, 3)) == 1
        obj = refineGrid(obj, iBlk);
        iRec = iBlk;
    end
    
end

% delete repeated point with the chosen block.
jRec = [];
for iDel = 1:4
    for jDel = 1:length(obj.pmExpo.block.hhat)
        
        if isequal(obj.pmExpo.block.hat{iRec}(iDel, 2:3), ...
                obj.pmExpo.block.hhat(jDel, :)) == 1
            
            jRec = [jRec; jDel];
            
        end
        
    end
end
obj.pmExpo.block.hhat(jRec, :) = [];
pmExpOtptTemp = obj.pmExpo.block.hhat;

% compare pmEXP_otptTemp with pmEXP_inptRaw, only to find whether there is
% a repeated pm point.
aRec = [];
for iComp = 1:size(pmExpOtptTemp, 1)
    
    a = ismember(pmExpOtptTemp(iComp, :), pmEXPinptRaw, 'rows');
    aRec = [aRec; a];
    if a == 1
        pmIdx = iComp;
    end
    
end

if any(aRec) == 1
    % if there is a repeated pm point, add 4 indices to new pm points and
    % put the old pm point at the beginning.
    idxToAdd = 4;
    
    pmExpOtptSpecVal = obj.pmExpo.block.hhat(pmIdx, :);
    
    pmExpOtptTemp(pmIdx, :) = [];
    
    for iComp1 = 1:length(pmExpInptPmTemp)
        b = ismember(pmExpOtptSpecVal, pmExpInptPmTemp(iComp1, 2:3), 'rows');
        if b == 1
            pmExpOtptSpecIdx = pmExpInptPmTemp(iComp1, 1);
        end
    end
    
    obj.pmExpo.block.hhat = [[pmExpOtptSpecIdx pmExpOtptSpecVal]; ...
        [(1:idxToAdd)' + length(pmEXPinptRaw) pmExpOtptTemp]];
    
else
    % if there is no repeated point, add 5 indices.
    idxToAdd = 5;
    
    obj.pmExpo.block.hhat = ...
        [(1:idxToAdd)' + length(pmEXPinptRaw) obj.pmExpo.block.hhat];
    
end

% equip index, find refined block and perform grid to block.

% NOTE: if only consider refined block, the number of added points do
% not need to be considered; however, if index is included, or total number
% of grid points is considered, then number of added points needs to be
% calculated. Principle: same size & same location block: +4; different size
% block: +5.
obj.pmExpo.temp.inpt = [obj.pmExpo.block.hat{iRec}; obj.pmExpo.block.hhat];
obj.gridtoBlockwithIndx;

% delete original block which needs to be refined, put final data together.
% pass value to a tmp var in case the origin (obj.pmExpo.block.hat) is modified.

pmExpoPass = obj.pmExpo.block.hat;
pmExpoPass(iRec) = [];
obj.pmExpo.block.hhat = [pmExpoPass; obj.pmExpo.temp.otpt];

% find the pm with indices in asending order.
pmExpOtptPm = cell2mat(obj.pmExpo.block.hhat);
pmExpOtptTemp = sortrows(pmExpOtptPm);
obj.pmExpo.hhat = unique(pmExpOtptTemp, 'rows');
obj.pmVal.hhat = 10 .^ obj.pmExpo.hhat(:, 2:3);
obj.pmVal.hhat = [obj.pmExpo.hhat(:, 1) obj.pmVal.hhat];
obj.pmVal.hat = 10 .^ obj.pmExpo.hat(:, 2:3);
obj.pmVal.hat = [obj.pmExpo.hat(:, 1) obj.pmVal.hat];
obj.no.pre.hhat = size(obj.pmVal.hhat, 1);
obj.no.block.hhat = size(obj.pmExpo.block.hhat, 1);
