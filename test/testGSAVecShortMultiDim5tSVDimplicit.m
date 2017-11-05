%% target.
testGSAVecShortMultiDimINP5t
aall = cat(2, a{:});

ahhat = [f -aall];

ares = ahhat' * ahhat;
ares = triu(ares);

%% test

ball = cat(2, b{:});

bhhat = [f -ball];

nbtotal = size(bhhat, 2);

nspec = size(ball, 2) / 2;

nsvd = 1;

bcell = mat2cell(bhhat', ones(nbtotal, 1), nd * nt);

bcellres = cellfun(@(v) reshape(v, nd, nt), bcell, 'un', 0);

[bl, bsig, br] = cellfun(@(v) svd(v, 'econ'), bcellres, 'un', 0);
bl = cellfun(@(v, w) v * w, bl, bsig, 'un', 0);
bl = cellfun(@(v) v(:, 1:nsvd), bl, 'un', 0);
br = cellfun(@(v) v(:, 1:nsvd), br, 'un', 0);
blspec = bl(nbtotal - nspec + 1:end);
brspec = br(nbtotal - nspec + 1:end);
%%
errBlkMain = cell(nt - 1);
for iBlk = 1:length(errBlkMain)
    for jBlk = 1:length(errBlkMain)
        
        if iBlk == 1 && jBlk == 1 % level 1, element 1
            blk = zeros(nbtotal, nbtotal);
            for i = 1:nbtotal
                for j = i:nbtotal
                    blk(i, j) = blk(i, j) + ...
                        trace(br{j}' * br{i} * bl{i}' * bl{j});
                end
            end
            errBlkMain(iBlk, jBlk) = {blk};
        
        elseif iBlk == 1 && jBlk ~= 1 % level 1, element n
            blk = zeros(nbtotal, nspec);
            nshift2 = jBlk - 1;
            brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
                v(1:nt - nshift2, :)], brspec, 'un', 0);
            for i = 1:nbtotal
                for j = 1:nspec
                    blk(i, j) = blk(i, j) + ...
                        trace(brspec2{j}' * br{i} * bl{i}' * blspec{j});
                    
                end
            end
            errBlkMain(iBlk, jBlk) = {blk};
            errBlkMain(jBlk, iBlk) = {zeros(nbtotal, nspec)'};
        elseif iBlk ~= 1 && iBlk <= jBlk
            blk = zeros(nspec, nspec);
            nshift1 = iBlk - 1;
            nshift2 = jBlk - 1;
            brspec1 = cellfun(@(v) [zeros(nshift1, nsvd); ...
                v(1:nt - nshift1, :)], brspec, 'un', 0);
            brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
                v(1:nt - nshift2, :)], brspec, 'un', 0);
            for i = 1:nspec
                if iBlk == jBlk
                    jpass = i;
                else
                    jpass = 1;
                end
                for j = jpass:nspec
                    
                    l1 = blspec{i};
                    l2 = blspec{j};
                    r1 = brspec1{i};
                    r2 = brspec2{j};
                    blk(i, j) = blk(i, j) + trace(r2' * r1 * l1' * l2);
                end
            end
            errBlkMain(iBlk, jBlk) = {blk};
            if iBlk ~= jBlk
                errBlkMain(jBlk, iBlk) = {zeros(nspec, nspec)'};
            end
            
        end
    end
end

errBlkMain = cell2mat(errBlkMain);
errBlkMain = triu(errBlkMain);