clear; clc;
% this script tests the speed of vectorising a matrix. 
n = 10000;
a = rand(n, n);

tic
b = a(:);
toc