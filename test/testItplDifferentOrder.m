clear; clc;
%%
% set a few vectors, test 2 cases: both 2-dimensional.
% case 1: interpolate vectors, then sum them, take l1 norm.
% case 2: sum vectors, take l1 norm, then interpolate. 
xl = 0;
xr = 2;
yl = 0;
yr = 2;
[gridx, gridy] = meshgrid([xl, xr], [yl, yr]);
x = 1.35;
y = 1.77;
% case 1: interpolate first.
v11 = (1:5)';
v12 = v11 + 1;
v13 = v11 - 1;

v21 = v11 - 6;
v22 = v11 + 5;
v23 = v11 - 4;

v31 = v11 - 2;
v32 = v11 - 7;
v33 = v11 + 6;

v41 = v11 - 8;
v42 = v11 - 6;
v43 = v11 - 9;

v11nm = norm(v11, 1);
v21nm = norm(v21, 1);
v31nm = norm(v31, 1);
v41nm = norm(v41, 1);

v1 = [v11 v12 v13];
v2 = [v21 v22 v23];
v3 = [v31 v32 v33];
v4 = [v41 v42 v43];

gridz = {v1 v2; v3 v4};
[otpt] = LagrangeInterpolation2D(x, y, gridx, gridy, gridz, 'matrix');
otptsum = sum(otpt, 2);
otptnm = norm(otptsum, 1);

% case 2: sum each first and take norm.
v1sum = sum(v1, 2);
v2sum = sum(v2, 2);
v3sum = sum(v3, 2);
v4sum = sum(v4, 2);

v1nm = norm(v1sum, 1);
v2nm = norm(v2sum, 1);
v3nm = norm(v3sum, 1);
v4nm = norm(v4sum, 1);

gridzsc = [v1nm v2nm; v3nm v4nm];
[otptsc] = LagrangeInterpolation2D(x, y, gridx, gridy, gridzsc, 'scalar');

% results: not same. 

% case 3: sum, interpolate, then norm.
gridzvec = {v1sum v2sum; v3sum v4sum};
[otptvec] = LagrangeInterpolation2D(x, y, gridx, gridy, gridzvec, 'matrix');
otptvecnm = norm(otptvec, 1);

% case 3 results in same with case 1, which is what we want. But this case
% will not work with multiplication of parameters and reduced variables.

%%
% test interpolation and norm in 1d, linear polynomial, with no sum of vectors.
% case 1: interpolate vector, then norm.
xcoord = [0 2]';
ycoord = {v11 v21}';
inptx = 1.5;
otpt1d = lagrange(xcoord, ycoord, inptx, 'matrix');
otpt1dnm = norm(otpt1d, 1);
% case 2: norm vector, then interpolate norm. 

ycoordsc = [v11nm; v21nm]';
otpt1dsc = lagrange(xcoord, ycoordsc, inptx, 'scalar');
% result: not same when there is negative values in vectors.
% same when all positive values in vectors.

%% 
% test interpolation and norm in 1d, linear polynomial, with sum of
% vectors.
% case 1: interpolate vector, sum, then norm.
ycoord1 = {v1, v2}';
otpt1 = lagrange(xcoord, ycoord1, inptx, 'matrix');
otpt1sm = sum(otpt1, 2);
otpt1nm = norm(otpt1sm, 1);
% case 2: sum, norm vector, then interpolate norm.
ycoord1sc = cellfun(@(v) norm(sum(v, 2), 1), ycoord1, 'un', 0);
ycoord1sc = cell2mat(ycoord1sc);
otpt1sc = lagrange(xcoord, ycoord1sc, inptx, 'scalar');
% result: not same when there is negative values in vectors.
% same when all positive values in vectors.

%%
% test interpolation and norm in 2d, linear polynomial, with no sum of vectors.
% case 1: interpolate vector, then norm.
gridz2 = {v11 v21; v31 v41};
otpt2 = LagrangeInterpolation2D(x, y, gridx, gridy, gridz2, 'matrix');
otpt2nm = norm(otpt2, 1);
% case 2: norm vector, then interpolate norm.
gridz2sc = [v11nm v21nm; v31nm v41nm];
otpt2sc = LagrangeInterpolation2D(x, y, gridx, gridy, gridz2sc, 'scalar');



























