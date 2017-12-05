% this script tests different cases of Frobenius norm.
clear; clc;
% case 1: fro norm of a matrix

a = rand(10);

nma = norm(a, 'fro');

% case 2: vector product
veca = a(:);
nmav = sqrt(veca' * veca);

% case 3: trace of matrix product
nmam = sqrt(trace(a' * a));