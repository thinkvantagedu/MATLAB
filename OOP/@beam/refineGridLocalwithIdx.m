function obj = refineGridLocalwithIdx(obj, type)
% Refine locally, only refine the block which surround the pm_maxLoc.
% input is 4 by 2 matrix representing 4 corner coordinate (in a column way).
% output is 5 by 2 matrix representing the computed 5 midpoints.
% This function is able to compute any number of given blocks, not just one
% block.
% input is a matrix, output is also a matrix, not suitable for cell.
% input hat block and maximum point, output hhat points, hhat blocks.
%% example: see testGSALocalRefiFunc.m

switch type
    
    case 'initial'
        
        pmEXP_max1 = obj.pmExpo.mid1;
        pmEXP_max2 = obj.pmExpo.mid2;
        
    case 'iteration'
        
        pmEXP_max1 = obj.pmExpo.max(1);
        pmEXP_max2 = obj.pmExpo.max(2);
        
end

pmEXP_inptPmTemp = cell2mat(obj.pmExpo.block.hat);

pmEXP_inptPm = pmEXP_inptPmTemp(:, 2:3);

pmEXP_inptRaw = unique(pmEXP_inptPm, 'rows');

no_block = length(obj.pmExpo.block.hat);

% find which block max pm point is in, refine.

for i_block = 1:no_block
    
    if inpolygon(pmEXP_max1, pmEXP_max2, ...
            obj.pmExpo.block.hat{i_block}(:, 2), ...
            obj.pmExpo.block.hat{i_block}(:, 3)) == 1
        obj = refineGrid(obj, i_block);
        i_rec = i_block;
    end
    
end

% delete repeated point with the chosen block.

j_rec = [];

for i_del = 1:4
    for j_del = 1:length(obj.pmExpo.block.hhat)
        
        if isequal(obj.pmExpo.block.hat{i_rec}(i_del, 2:3), ...
                obj.pmExpo.block.hhat(j_del, :)) == 1
           
            j_rec = [j_rec; j_del];
            
        end
        
    end
end

obj.pmExpo.block.hhat(j_rec, :) = [];
pmEXP_otptTemp = obj.pmExpo.block.hhat;

% compare pmEXP_otptTemp with pmEXP_inptRaw, only to find whether there is
% a repeated pm point.
aRec = [];
for iComp = 1:size(pmEXP_otptTemp, 1)
   
    a = ismember(pmEXP_otptTemp(iComp, :), pmEXP_inptRaw, 'rows');
    aRec = [aRec; a];
    if a == 1
        pmIdx = iComp;
    end
       
end

if any(aRec) == 1
    % if there is a repeated pm point, add 4 indices to new pm points and 
    % put the old pm point at the beginning.
    idxToAdd = 4;
    
    pmEXP_otptSpecVal = obj.pmExpo.block.hhat(pmIdx, :);
    
    pmEXP_otptTemp(pmIdx, :) = [];
    
    for iComp1 = 1:length(pmEXP_inptPmTemp)
        b = ismember(pmEXP_otptSpecVal, pmEXP_inptPmTemp(iComp1, 2:3), 'rows');
        if b == 1
           pmEXP_otptSpecIdx = pmEXP_inptPmTemp(iComp1, 1);
        end
    end
    
    obj.pmExpo.block.hhat = [[pmEXP_otptSpecIdx pmEXP_otptSpecVal]; ...
        [(1:idxToAdd)' + length(pmEXP_inptRaw) pmEXP_otptTemp]];
    
else
    % if there is no repeated point, add 5 indices.
    idxToAdd = 5;
    
    obj.pmExpo.block.hhat = ...
        [(1:idxToAdd)' + length(pmEXP_inptRaw) obj.pmExpo.block.hhat];
    
end

% equip index, find refined block and perform grid to block.

% NOTE: if only consider refined block, then the number of added points do
% not need to be considered; however, if index is included, or total number
% of grid points is considered, then number of added points needs to be
% calculated. Principle: same size & same location block: +4; different size
% block: +5.
obj.pmExpo.temp.inpt = [obj.pmExpo.block.hat{i_rec}; obj.pmExpo.block.hhat];

obj.gridtoBlockwithIndx;

% delete original block which needs to be refined, put final data together.
% pass value to a temp var in case the origin (obj.pmExpo.block.hat) is modified.

pmExpoPass = obj.pmExpo.block.hat;

pmExpoPass(i_rec) = [];

obj.pmExpo.block.hhat = [pmExpoPass; obj.pmExpo.temp.otpt];


% find the pm with indices in asending order.
pmEXP_otptPm = cell2mat(obj.pmExpo.block.hhat);

pmEXP_otptTemp = sortrows(pmEXP_otptPm);

obj.pmExpo.hhat = unique(pmEXP_otptTemp, 'rows');

obj.pmVal.hhat = 10 .^ obj.pmExpo.hhat(:, 2:3);
obj.pmVal.hhat = [obj.pmExpo.hhat(:, 1) obj.pmVal.hhat];
obj.pmVal.hat = 10 .^ obj.pmExpo.hat(:, 2:3);
obj.pmVal.hat = [obj.pmExpo.hat(:, 1) obj.pmVal.hat];

obj.no.pre.hhat = size(obj.pmVal.hhat, 1);
obj.no.block.hhat = size(obj.pmExpo.block.hhat, 1);
