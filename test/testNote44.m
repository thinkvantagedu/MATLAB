clear; clc;
% this script tests note 44: SVD error
a = rand(30, 100);

[u, s, v] = svd(a);
% test1
nm = norm(a, 'fro');
nmua = norm(u * a, 'fro');

% test2
nmusigvT = norm(u * s * v', 'fro');
nmtrvsigTuT = sqrt(trace(v * s' * (u)' * u * s * v'));
nmtrvsigT = sqrt(trace(v * (s)' * s * v'));

nmsigvT = norm(s * v', 'fro');
nmsigvTv = norm(s * (v)' * v, 'fro');
nmsig = norm(s, 'fro');

% test3
nt = 5;
ut = u(:, 1:nt);
st = s(1:nt, 1:nt);
vt = v(:, 1:nt);

nmt = norm(ut * st * vt', 'fro');

tper = nmt / nm;
tpers = norm(st, 'fro') / norm(s, 'fro');
tperstr = sqrt(trace(st' * st)) / sqrt(trace(s' * s));