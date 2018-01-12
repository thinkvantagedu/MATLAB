clear; clc;
% this script tests note 60.
% define 2 samples.
p1 = 1;
p2 = 5;
xco = [p1; p2];
% define 2 matrices.
m1 = rand(10, 1);
m2 = rand(10, 1);
yco1 = {m1; m2};
% output location.
p = 2.5;

% case 1: interpolate matrix then mTm.
o1 = lagrange(xco, yco1, p, 'matrix');
mtm1 = o1' * o1;

% case 2: mTm then interpolate.
m1t = m1' * m1;
m2t = m2' * m2;
yco2 = {m1t; m2t};
mtm2 = lagrange(xco, yco2, p, 'matrix');

% extra test: norm first and itpl first. 
% case 3: norm first then itpl.
nm1 = norm(m1, 'fro');
nm2 = norm(m2, 'fro');

yco3 = [nm1; nm2];
o3 = lagrange(xco, yco3, p, 'scalar');

% case 4: itpl first then norm.
o4 = norm(o1, 'fro');