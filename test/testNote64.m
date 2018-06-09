clear; clc;
% this script tests note 64 for 1d Lagrange interpolation.
y1 = [1 2; 3 4; 5 6];
y2 = [8 7; 6 5; 4 3];

x1 = -1;
x2 = 1;

xco = {x1; x2};
yco = {y1; y2};

inptx = 0.5;
%% case 1:
% compute Lagrange interpolation of displacements.
[coeff, disp1] = lagrange(inptx, xco, yco);
uTu1 = disp1' * disp1;

%% case 2 = case 1:
y1Ty1 = y1' * y1;
y2Ty2 = y2' * y2;
y1Ty2 = y1' * y2;
cfcfT = coeff * coeff';
uTu2 = y1Ty1 * cfcfT(1, 1) + y1Ty2 * cfcfT(1, 2) + ...
    y1Ty2' * cfcfT(2, 1) + y2Ty2 * cfcfT(2, 2);

%% case 3: project afterwards.
al = [1 2 3; 4 5 6];
proj1 = al' * uTu1 * al;

%% case 4: project first then interpolate.
y1Ty1proj = al' * y1Ty1 * al;
y2Ty2proj = al' * y2Ty2 * al;
y1Ty2proj = al' * y1Ty2 * al;
proj2 = y1Ty1proj * cfcfT(1, 1) + y1Ty2proj * cfcfT(1, 2) + ...
    y1Ty2proj' * cfcfT(2, 1) +  + y2Ty2proj * cfcfT(2, 2);