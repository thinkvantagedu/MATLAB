clear; clc;
% PART 1.
a = magic(8);
% number of singular values left after truncation.
n = 2;
[u, s, v] = svd(a, 0);
% sum all singular values.
ds = diag(s);
dss = sqrt(sum(ds .^ 2));
% sum first n singular values
dssn = sqrt(sum((ds(1:n)).^2));
% work out the error after truncation.
dsp = dssn / dss;

% PART 2
% multiply left singular vectors with singular values
u = u * s;
% select the first n singular vectors, i.e. to truncate
us = u(:, 1:n);
vs = v(:, 1:n);
% reconstruct the solution
ur = us * vs';
% work out the error
up = norm(ur, 'fro') / norm(a, 'fro');