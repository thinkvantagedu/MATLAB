% follow testGSAVecShortMultiDimINP5t, apply SVD on each response, while
% maintain the same efficiency with testGSAVecShortMultiDim5t.

%% target.
testGSAVecShortMultiDimINP5t;

aall = cat(2, a{:});

ahhat = [f -aall];
natotal = size(ahhat, 2);
ares = ahhat' * ahhat;
ares = triu(ares);
ashort = reshape(ahhat, [nd, numel(ahhat) / nd]);

aresshort = ashort' * ashort;

atotalno_t = size(aall, 2);

%% same solution with only 2 space-time responses and apply SVD on them.
nsvd = 3;
ball = cat(2, b{:});

% all space time vectors.
bhhat = [f -ball];

% number of all space time vectors.
nbtotal = size(bhhat, 2);
nspec = size(ball, 2) / 2;
funcselect = @(x) x(:, (nbtotal - nspec + 1) : nbtotal);

% put space time vectors into cells.
bhhatcv = mat2cell(bhhat, nd * nt, ones(nbtotal, 1));

% reshape cell space time vectors into matrices.
bshortblk = cellfun(@(v) reshape(v, [nd, nt]), bhhatcv, 'un', 0);
bshortblk = bshortblk';

% apply SVD.
[bl, bsig, br] = cellfun(@(v) svd(v, 'econ'), bshortblk, 'un', 0);
keyboard
% multiply bl with bsig.
bl = cellfun(@(v, w) v * w, bl, bsig, 'un', 0);

% dump unwanted vectors.
bl = cellfun(@(v) v(:, 1:nsvd), bl, 'un', 0);
br = cellfun(@(v) v(:, 1:nsvd), br, 'un', 0);
blspec = bl(end - nspec + 1 : end);
brspec = br(end - nspec + 1 : end);
% blresspec = cellfun(funcselect, blres, 'un', 0);
% brresspec = cellfun(funcselect, brres, 'un', 0);

errBlkMain = cell(nt - 1);

funcete = @(x1, x2, y1, y2) y2' * y1 * x1' * x2;

for iBlk = 1:length(errBlkMain)
    % j denotes jth element in each level, j \in [1, n]
    for jBlk = iBlk:length(errBlkMain)
        if iBlk == 1 && jBlk == 1 % level 1, element 1
            otpt = zeros(nbtotal, nbtotal);
            for m = 1:nbtotal
                for n = m:nbtotal
                    l1 = bl{n};
                    l2 = bl{m};
                    r1 = br{n};
                    r2 = br{m};
                    otpt(m, n) = otpt(m, n) + ...
                        trace(r2' * r1 * l1' * l2);
                end
            end
            
        elseif iBlk == 1 && jBlk ~= 1 % level 1, element n
            otpt = zeros(nbtotal, nspec);
            bltemp1 = bl(jBlk:end);
            brtemp1 = br(jBlk:end);
            blspectemp1 = blspec(1:nt - jBlk + 1);
            brspectemp1 = brspec(1:nt - jBlk + 1);
            
            
            
            keyboard
            errBlkMain{jBlk, iBlk} = {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
        end
    end
end
