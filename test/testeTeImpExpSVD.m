clear; clc;
nd = 4;
nt = 5;
nsvd = 2;

e1vec = (1:20)';
e2vec = e1vec + 5;
% cell with e vectors.
eveccell = {e1vec e2vec};
% 
evectevec = cellfun(@(v) v' * v, eveccell, 'un', 0);



% cell with e matrices.
ecell = cellfun(@(v) reshape(v, [nd, nt]), eveccell, 'un', 0);


ete = cellfun(@(v) trace(v' * v), ecell, 'un', 0);

% cell with SVD vectors.

[el, esig, er] = cellfun(@(v) svd(v, 'econ'), ecell, 'un', 0);
el = cellfun(@(u, v) u * v, el, esig, 'un', 0);
el = cellfun(@(v) v(:, 1:nsvd), el, 'un', 0);
er = cellfun(@(v) v(:, 1:nsvd), er, 'un', 0);

etesvd = cellfun(@(l1, l2, r1, r2) ...
    trace(r1 * l1' * l2 * r2'), el, el, er, er, 'un', 0); % trace

etesvd1 = cellfun(@(l1, l2, r1, r2) ...
    trace(r2' * r1 * l1' * l2), el, el, er, er, 'un', 0); % trace rearranged   