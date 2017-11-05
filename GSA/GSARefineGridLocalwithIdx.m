function [pmEXP_otpt, pmEXP_otptRaw] = GSARefineGridLocalwithIdx...
    (pmEXP_inpt, pmEXP_maxLoc1, pmEXP_maxLoc2)
%% refine locally, only refine the block which surround the pm_maxLoc.

% pm_inpt is 4 by 2 matrix representing 4 corner coordinate (in a column way).
% pm_comb_otpt is 5 by 2 matrix representing the computed 5 midpoints.
% This function is able to compute any number of given blocks, not just one
% block.
% inpt is a matrix, otpt is also a matrix, not suitable for cell.

%% example: see testGSALocalRefiFunc.m

pmEXP_inptPmTemp = cell2mat(pmEXP_inpt);

pmEXP_inptPm = pmEXP_inptPmTemp(:, 2:3);

pmEXP_inptRaw = unique(pmEXP_inptPm, 'rows');

no_block = length(pmEXP_inpt);

% find which block max pm point is in, refine.

for i_block = 1:no_block
    
    if inpolygon(pmEXP_maxLoc1, pmEXP_maxLoc2, ...
            pmEXP_inpt{i_block}(:, 2), ...
            pmEXP_inpt{i_block}(:, 3)) == 1
        pmEXP_otpt = GSARefineGrid(pmEXP_inpt{i_block}(:, 2:3));
        i_rec = i_block;
    end
    
end

% delete repeated point with the chosen block.

j_rec = [];

for i_del = 1:4
    for j_del = 1:length(pmEXP_otpt)
        
        if isequal(pmEXP_inpt{i_rec}(i_del, 2:3), pmEXP_otpt(j_del, :)) == 1
           
            j_rec = [j_rec; j_del];
            
        end
        
    end
end

pmEXP_otpt(j_rec, :) = [];
pmEXP_otptTemp = pmEXP_otpt;

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
    
    pmEXP_otptSpecVal = pmEXP_otpt(pmIdx, :);
    
    pmEXP_otptTemp(pmIdx, :) = [];
    
    for iComp1 = 1:length(pmEXP_inptPmTemp)
        b = ismember(pmEXP_otptSpecVal, pmEXP_inptPmTemp(iComp1, 2:3), 'rows');
        if b == 1
           pmEXP_otptSpecIdx = pmEXP_inptPmTemp(iComp1, 1);
        end
    end
    
    pmEXP_otpt = [[pmEXP_otptSpecIdx pmEXP_otptSpecVal]; ...
        [(1:idxToAdd)' + length(pmEXP_inptRaw) pmEXP_otptTemp]];
    
else
    % if there is no repeated point, add 5 indices.
    idxToAdd = 5;
    
    pmEXP_otpt = [(1:idxToAdd)' + length(pmEXP_inptRaw) pmEXP_otpt];
    
end

% equip index, find refined block and perform grid to block.

% NOTE: if only consider refined block, then the number of added points do
% not need to be considered; however, if index is included, or total number
% of grid points is considered, then number of added points needs to be
% calculated. Principle: same size & same location block: +4; different size
% block: +5.
pmEXP_refiGrid = [pmEXP_inpt{i_rec}; pmEXP_otpt];

pmEXP_refiGridtoBlk = GSAGridtoBlockwithIndx(pmEXP_refiGrid);

% delete original block which needs to be refined, put final data together.

pmEXP_inpt(i_rec) = [];

pmEXP_otpt = [pmEXP_inpt; pmEXP_refiGridtoBlk];

% find the pm with indices in asending order.
pmEXP_otptPm = cell2mat(pmEXP_otpt);

pmEXP_otptTemp = sortrows(pmEXP_otptPm);

pmEXP_otptRaw = unique(pmEXP_otptTemp, 'rows');
