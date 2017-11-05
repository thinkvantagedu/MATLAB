clear; clc;
nd = 100;
nt = 20;
nsvd = 1;
e1 = rand(nd * nt, 1);
e2 = rand(nd * nt, 1);
%% speed test: =================================================================
%%
tic
ete = e1' * e2;
toc
%%
e1m = reshape(e1, [nd, nt]);
e2m = reshape(e2, [nd, nt]);

[l1, sig1, r1] = svd(e1m, 'econ');
[l2, sig2, r2] = svd(e2m, 'econ');

l1 = l1 * sig1;
l2 = l2 * sig2;

l1 = l1(:, 1:nsvd);
l2 = l2(:, 1:nsvd);
r1 = r1(:, 1:nsvd);
r2 = r2(:, 1:nsvd);

tic
etesvd = trace(r2' * r1 * l1' * l2);
toc


%% equivalence test: ===========================================================
% norm of error sum.
esum = e1 + e2;
esumnorm = norm(esum, 'fro');
% equivalence of norm. 
em = [e1 e2];
emtem = em' * em;
emnorm = sqrt(sum(emtem(:)));