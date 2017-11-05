nsvd = 2;

bcell = mat2cell(bhhat', ones(nbtotal, 1), nd * nt);

bcellres = cellfun(@(v) reshape(v, nd, nt), bcell, 'un', 0);

[bl, bsig, br] = cellfun(@(v) svd(v, 'econ'), bcellres, 'un', 0);
bl = cellfun(@(v, w) v * w, bl, bsig, 'un', 0);
bl = cellfun(@(v) v(:, 1:nsvd), bl, 'un', 0);
br = cellfun(@(v) v(:, 1:nsvd), br, 'un', 0);
blspec = bl(nbtotal - nspec + 1:end);
brspec = br(nbtotal - nspec + 1:end);

%% level 1, element 1
blk1 = zeros(nbtotal, nbtotal);

for i = 1:nbtotal
    for j = 1:nbtotal
        l1 = bl{i};
        l2 = bl{j};
        r1 = br{i};
        r2 = br{j};
        blk1(i, j) = blk1(i, j) + trace(r2' * r1 * l1' * l2);
    end
end

blk1 = triu(blk1);

%% u1 shift 0, u2 shift 1. level 1, element n
nshift1 = 0;
nshift2 = 1;
blk2 = zeros(nbtotal, nspec);
brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
    v(1:nt - nshift2, :)], brspec, 'un', 0);

for i = 1:nbtotal
    for j = 1:nspec
        
        l1 = bl{i};
        l2 = blspec{j};
        r1 = br{i};
        r2 = brspec2{j};
        blk2(i, j) = blk2(i, j) + trace(r2' * r1 * l1' * l2);
    end
end

%% u1 shift 0, u2 shift 2. level 1, element n
nshift1 = 0;
nshift2 = 2;
blk3 = zeros(nbtotal, nspec);
brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
    v(1:nt - nshift2, :)], brspec, 'un', 0);

for i = 1:nbtotal
    for j = 1:nspec
        
        l1 = bl{i};
        l2 = blspec{j};
        r1 = br{i};
        r2 = brspec2{j};
        blk3(i, j) = blk3(i, j) + trace(r2' * r1 * l1' * l2);
    end
end

%% u1 shift 1, u2 shift 1. level m, element m
nshift1 = 1;
nshift2 = 1;
blk4 = zeros(nspec, nspec);
brspec1 = cellfun(@(v) [zeros(nshift1, nsvd); ...
    v(1:nt - nshift1, :)], brspec, 'un', 0);
brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
    v(1:nt - nshift2, :)], brspec, 'un', 0);

for i = 1:nspec
    for j = 1:nspec
        
        l1 = blspec{i};
        l2 = blspec{j};
        r1 = brspec1{i};
        r2 = brspec2{j};
        blk4(i, j) = blk4(i, j) + trace(r2' * r1 * l1' * l2);
    end
end

%% u1 shift 2, u2 shift 2. level m, element m
nshift1 = 2;
nshift2 = 2;
blk5 = zeros(nspec, nspec);
brspec1 = cellfun(@(v) [zeros(nshift1, nsvd); ...
    v(1:nt - nshift1, :)], brspec, 'un', 0);
brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
    v(1:nt - nshift2, :)], brspec, 'un', 0);

for i = 1:nspec
    for j = 1:nspec
        
        l1 = blspec{i};
        l2 = blspec{j};
        r1 = brspec1{i};
        r2 = brspec2{j};
        blk5(i, j) = blk5(i, j) + trace(r2' * r1 * l1' * l2);
    end
end

%% u1 shift 1, u2 shift 2. level m, element n
nshift1 = 1;
nshift2 = 2;
blk6 = zeros(nspec, nspec);
brspec1 = cellfun(@(v) [zeros(nshift1, nsvd); ...
    v(1:nt - nshift1, :)], brspec, 'un', 0);
brspec2 = cellfun(@(v) [zeros(nshift2, nsvd); ...
    v(1:nt - nshift2, :)], brspec, 'un', 0);

for i = 1:nspec
    for j = 1:nspec
        
        l1 = blspec{i};
        l2 = blspec{j};
        r1 = brspec1{i};
        r2 = brspec2{j};
        blk6(i, j) = blk6(i, j) + trace(r2' * r1 * l1' * l2);
    end
end


