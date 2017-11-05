%% target.
testGSAVecShortMultiDimINP4t
aall = cat(2, a{:});

ahhat = [f -aall];

ares = ahhat' * ahhat;
ares = triu(ares);

%% test

ball = cat(2, b{:});

bhhat = [f -ball];

nbtotal = size(bhhat, 2);

nspec = size(ball, 2) / 2;

funcete = @(x, y) x' * y;

funcselect = @(x) x(:, (nbtotal - nspec + 1) : nbtotal);
% same time step space response aligned together.

bshortblkcolres = mat2cell(bhhat, nd * ones(nt, 1), nbtotal);

% special time step space resonse aligned together.
bshortblkcolresspec = cellfun(funcselect, bshortblkcolres, 'un', 0);

errBlkMain = cell(nt - 1);
%% Horizontal level m - 1, specify cell blocks in each level. 
% i denotes levels, i \in [1, m]
for iBlk = 1:length(errBlkMain)
    % j denotes jth element in each level, j \in [1, n]
    for jBlk = iBlk:length(errBlkMain)        
        
        if iBlk == 1 && jBlk == 1 % level 1, element 1
            errBlkCell = cellfun...
                (funcete, bshortblkcolres, bshortblkcolres, 'un', 0);
            errBlkMain{iBlk, jBlk} = {sum(cat(3, errBlkCell{:}), 3)};
            
            
        elseif iBlk == 1 && jBlk ~= 1 % level 1, element n
            blktemp1 = bshortblkcolres(jBlk:end);
            blktemp2 = bshortblkcolresspec(1:nt - jBlk + 1);
            bmainblkcelltemp = cellfun(funcete, blktemp1, blktemp2, 'un', 0);
            errBlkMain{iBlk, jBlk} = {sum(cat(3, bmainblkcelltemp{:}), 3)};
            errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
            
        elseif iBlk ~= 1 && iBlk == jBlk % level m, element m
            blktemp1 = bshortblkcolresspec(1:nt - jBlk + 1);
            bmainblkcelltemp = cellfun(funcete, blktemp1, blktemp1, 'un', 0);
            errBlkMain{iBlk, jBlk} = {sum(cat(3, bmainblkcelltemp{:}), 3)};
            
        elseif iBlk ~= 1 && iBlk ~= jBlk % level m, element n
            blktemp1 = bshortblkcolresspec...
                (jBlk - iBlk + 1:nt - iBlk + 1);
            blktemp2 = bshortblkcolresspec(1:nt - jBlk + 1);
            bmainblkcelltemp = cellfun(funcete, blktemp1, blktemp2, 'un', 0);
            errBlkMain{iBlk, jBlk} = {sum(cat(3, bmainblkcelltemp{:}), 3)};
            errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
            
        end
    end
end

errBlkMain = cell2mat(cellfun(@(v) cell2mat(v), errBlkMain, 'un', 0));
errBlkMain = triu(errBlkMain);