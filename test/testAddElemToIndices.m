clear; clc;
a = 1:36;

n = round((sqrt(8 * numel(a) + 1) - 1) / 2);
M = zeros(n, n);
M(triu(true(n))) = a;