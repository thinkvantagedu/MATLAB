clear; clc;
% this script tests 2 cases: 1. compute norm by vector product; 2. compute
% norm by matrix trace. 
a = rand(12, 4);

nma = norm(a, 'fro');

% case 1: vector product

veca = a(:);

nmavec = sqrt(veca' * veca);

% case 2: matrix trace

nmamtx = sqrt(trace(a' * a));

% result: vector product = matrix trace.