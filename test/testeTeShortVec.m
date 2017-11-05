clear; clc;
nd = 3;
nt = 2;
nsvd = 1;
nbtotal = 2;

b1 = [zeros(2, 1); (1:4)'];
b2 = [zeros(2, 1); (3:6)'];

%% eTe.
e = [b1 b2];

ete = e' * e;

%% SVD.
bhhat = {b1 b2};

bshortblk = cellfun(@(v) reshape(v, [nd, nt]), bhhat, 'un', 0);
bshortblk = bshortblk';

[bl, bsig, br] = cellfun(@(v) svd(v, 'econ'), bshortblk, 'un', 0);

bl = cellfun(@(v, w) v * w, bl, bsig, 'un', 0);

bl = cellfun(@(v) v(:, 1:nsvd), bl, 'un', 0);
br = cellfun(@(v) v(:, 1:nsvd), br, 'un', 0);

blres = cellfun(@(v) reshape(v, [nd * nsvd, 1]), bl, 'un', 0);
brres = cellfun(@(v) reshape(v, [nt * nsvd, 1]), br, 'un', 0);

blres = [blres{:}];
brres = [brres{:}];

blres = mat2cell(blres, nd * ones(1, nsvd), ones(nbtotal, 1));
brres = mat2cell(brres, nt * ones(1, nsvd), ones(nbtotal, 1));

res = zeros(nbtotal);

l1 = blres{1, 1};
l2 = blres{1, 1};
r1 = brres{1, 1};
r2 = brres{1, 1};

res1 = r2' * r1 * l1' * l2;

l1 = blres{1, 1};
l2 = blres{1, 2};
r1 = brres{1, 1};
r2 = brres{1, 2};

res2 = r2' * r1 * l1' * l2;

l1 = blres{1, 2};
l2 = blres{1, 1};
r1 = brres{1, 2};
r2 = brres{1, 1};

res3 = r2' * r1 * l1' * l2;

l1 = blres{1, 2};
l2 = blres{1, 2};
r1 = brres{1, 2};
r2 = brres{1, 2};

res4 = r2' * r1 * l1' * l2;