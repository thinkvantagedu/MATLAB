clear; clc;
nd = 3;
nt = 4;
nsvd = 1;
funcete = @(x, y) x' * y;

uf = [zeros(nd, 1); (1:9)'];
u1 = [zeros(nd, 1); (3:11)'];
u1s1 = [zeros(2 * nd, 1); (3:8)'];
u1s2 = [zeros(3 * nd, 1); (3:5)'];

%%
ahhat = [uf u1 u1s1 u1s2];

ata = ahhat' * ahhat;
ata = triu(ata);

%%
bhhat = [uf u1];

nbtotal = size(bhhat, 2);

bshortblkcolres = mat2cell(bhhat, nd * ones(nt, 1), nbtotal);

bshortblkcolresspec = cellfun(@(v) v(:, 2), bshortblkcolres, 'un', 0);

errBlkMain = cell(nt - 1);

for iBlk = 1:length(errBlkMain)
    % j denotes jth element in each level, j \in [1, n]
    for jBlk = iBlk:length(errBlkMain)        
        
        if iBlk == 1 && jBlk == 1 % level 1, element 1
            errBlkCell = cellfun...
                (funcete, bshortblkcolres, bshortblkcolres, 'un', 0);
            errBlkCell = {sum(cat(3, errBlkCell{:}), 3)};
            errBlkCell = triu(errBlkCell{:});
            errBlkMain{iBlk, jBlk} = {errBlkCell};
            
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
            errBlkCell = {sum(cat(3, bmainblkcelltemp{:}), 3)};
            errBlkCell = triu(errBlkCell{:});
            errBlkMain{iBlk, jBlk} = {errBlkCell};
            
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

%%
bcell = {uf u1};
bcell = cellfun(@(v) reshape(v, [nd, nt]), bcell, 'un', 0);
[bl, bsig, br] = cellfun(@(v) svd(v, 'econ'), bcell, 'un', 0);
bl = cellfun(@(v, w) v * w, bl, bsig, 'un', 0);
bl = cellfun(@(v) v(:, 1:nsvd), bl, 'un', 0);
br = cellfun(@(v) v(:, 1:nsvd), br, 'un', 0);

bl1 = cell2mat(bl);

bl1 = {bl1};

br1 = cell2mat(br);

br1 = mat2cell(br1, ones(nt, 1), nbtotal);

bl1spec = cellfun(@(v) v(:, 2), bl1, 'un', 0);
br1spec = cellfun(@(v) v(:, 2), br1, 'un', 0);

%%
errBlkMain1 = cell(nt - 1);

for iBlk = 1:length(errBlkMain1)
    for jBlk = 1:length(errBlkMain1)
        if iBlk == 1 && jBlk == 1
            errtemp = zeros(2, 2);
            for m = 1:2
                for n = m:2
                    l1 = bl{n};
                    l2 = bl{m};
                    r1 = br{m};
                    r2 = br{n};
                    errtemp(m, n) = errtemp(m, n) + r2' * r1 * l1' * l2;
                end
            end
            
        elseif iBlk == 1 && jBlk ~= 1 % level 1, element n
            errtemp = zeros(2, 2);
            for m = 1:2
                for n = m : 2
                    
                end
            end
        end
    end
end



































