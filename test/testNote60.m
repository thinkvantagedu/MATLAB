clear; clc;
% this script tests note 60.
% define 2 samples.
p1 = 1;
p2 = 5;
xco = [p1; p2];
% define 2 matrices.
u1 = [1 2 3 4]';
u2 = [4 3 2 1]';
yco1 = {u1; u2};
% output location.
p = 5;

% case 1: interpolate matrix then mTm.
cf = lagrange(p, {p1; p2});
uotpt1 = u1 * cf(1) + u2 * cf(2);
utu1 = uotpt1' * uotpt1;

% case 2: mTm then interpolate.
u1tu1 = u1' * u1;
u2tu2 = u2' * u2;
u1tu2 = u1' * u2;
cftcf = num2cell(cf * cf');
utu2cell = {u1tu1 u1tu2; u1tu2' u2tu2};
uotpt2 = cell2mat(cellfun(@(u, v) u * v, utu2cell, cftcf, 'un', 0)); 
utu2 = sum(uotpt2(:));

% case 3: approximate with uiTui only.
utu3cell = {u1tu1 0; 0 u2tu2};
uotpt3 = cell2mat(cellfun(@(u, v) u * v, utu3cell, cftcf, 'un', 0)); 
utu3 = sum(uotpt3(:));