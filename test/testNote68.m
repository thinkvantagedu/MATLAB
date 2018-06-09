clear; clc;
% this script tests note 68 for 2d Lagrange interpolation.
z1 = [1 2; 3 4; 5 6];
z2 = [8 7; 6 5; 4 3];
z3 = [3 4; 3 2; 1 5];
z4 = [5 6; 8 9; 4 7];

inptx = 0.5;
inpty = -0.5;
gridx = [-1 1; -1 1];
gridy = [-1 -1; 1 1];
gridz = {z1 z2; z3 z4};
%% interpolate u.
% case 1: interpolate in 2d.
[cf1, cf2, otpt] = LagrangeInterpolation2D(inptx, inpty, gridx, gridy, gridz);
% case 2: interpolate in x, then y, see if the coefficients are correct.
xco1d = {-1 1}; % 1d = x direction.
zco1d12 = {z1; z2};
[cf1d, otpt1d12] = lagrange(inptx, xco1d, zco1d12);
zco1d34 = {z3; z4};
[~, otpt1d34] = lagrange(inptx, xco1d, zco1d34);

yco2d = {-1 1}; % 2d = y direction.
zco2d = {otpt1d12; otpt1d34};
[cf2d, otpt2d] = lagrange(inpty, yco2d, zco2d);

%% interpolate uTu.
% case 3: interpolate then take uTu.
uTu1 = otpt' * otpt;

% case 4: uTu then interpolate.
cfcf12 = cf1d * cf2d';

otpt_ = z1 * cfcf12(1, 1) + z2 * cfcf12(2, 1) + ...
    z3 * cfcf12(1, 2) + z4 * cfcf12(2, 2);

cfcf1212 = cfcf12(:) * (cfcf12(:))';

z11 = z1' * z1;
z22 = z2' * z2;
z33 = z3' * z3;
z44 = z4' * z4;
z12 = z1' * z2;
z13 = z1' * z3;
z14 = z1' * z4;
z23 = z2' * z3;
z24 = z2' * z4;
z34 = z3' * z4;

zcell = {z11 z12 z13 z14; z12' z22 z23 z24; ...
    z13' z23' z33 z34; z14' z24' z34' z44};
cfcell = num2cell(cfcf1212);

uTu2 = cellfun(@(u, v) u * v, zcell, cfcell, 'un', 0);
uTu2 = sum(cat(3,uTu2{:}),3);

% %% case 1:
% % compute Lagrange interpolation of displacements.
% [coeff, disp1] = lagrange(inptxy, xco, yco);
% uTu1 = disp1' * disp1;
% 
% %% case 2 = case 1:
% y1Ty1 = y1' * y1;
% y2Ty2 = y2' * y2;
% y1Ty2 = y1' * y2;
% cfcfT = coeff * coeff';
% uTu2 = y1Ty1 * cfcfT(1, 1) + y1Ty2 * cfcfT(1, 2) + ...
%     y1Ty2' * cfcfT(2, 1) +  + y2Ty2 * cfcfT(2, 2);
% 
% %% case 3: project afterwards.
% al = [1 2 3; 4 5 6];
% proj1 = al' * uTu1 * al;
% 
% %% case 4: project first then interpolate.
% y1Ty1proj = al' * y1Ty1 * al;
% y2Ty2proj = al' * y2Ty2 * al;
% y1Ty2proj = al' * y1Ty2 * al;
% proj2 = y1Ty1proj * cfcfT(1, 1) + y1Ty2proj * cfcfT(1, 2) + ...
%     y1Ty2proj' * cfcfT(2, 1) +  + y2Ty2proj * cfcfT(2, 2);