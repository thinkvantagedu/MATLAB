clear; clc;
a = rand(1000, 100);
[al, as, ar] = svd(a, 0);
n = 50;
al = al(:, 1:n);
as = as(1:n, 1:n);
ar = ar(:, 1:n);
tic
for i = 1:10000
    trace()