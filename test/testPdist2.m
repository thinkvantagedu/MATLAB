clear; clc;
% this script tests the use of function pdist2, and howt ofind the closest
% point in a n-by-2 matrix to a given point.

% give a matrix denoting unit square.
m = [0 0; 1 0; 0 1; 1 1];
% test point.
p = [0.1 0.1];

[o1, o2] = pdist2(m, p, 'euclidean', 'Smallest', 1); % otpt lists distance 
% between p and each m.

o3 = pdist2(m, p, 'euclidean');