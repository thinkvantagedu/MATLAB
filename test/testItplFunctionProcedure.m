clear; clc;
% this test aim to analyze the procedure of multi-dimensional Lagrange
% interpolation, find out where the interpolation polynomial is, and what
% they are. 
%% 
v11 = (1:5)';
v12 = v11 + 1;
v13 = v11 - 1;
v21 = v11 + 3;
v22 = v11 + 5;
v23 = v11 - 4;
v31 = v11 - 2;
v32 = v11 - 7;
v33 = v11 + 6;
v41 = v11 + 8;
v42 = v11 - 6;
v43 = v11 - 9;
v1 = [v11 v12 v13];
v2 = [v21 v22 v23];
v3 = [v31 v32 v33];
v4 = [v41 v42 v43];
v1sum = sum(v1, 2);
v2sum = sum(v2, 2);
v3sum = sum(v3, 2);
v4sum = sum(v4, 2);
v1nm = norm(v1sum, 1);
v2nm = norm(v2sum, 1);
v3nm = norm(v3sum, 1);
v4nm = norm(v4sum, 1);

%% test for 1d scalar case.
% x1 = 4;
% x2 = 5;
% x3 = 6;
% 
% y1 = 10;
% y2 = 5.25; 
% y3 = 1;
% 
% x = [x1 x2 x3]';
% y = [y1 y2 y3]';
% 
% xsc = 18;
% 
% res = lagrange(x, y, xsc, 'scalar');

%% test for 2d scalar case.
xl = 0;
xr = 2;
yl = 1;
yr = 3;
x = 1.5;
y = 2;
[gridx, gridy] = meshgrid([xl, xr], [yl, yr]);
gridz = [v1nm v2nm; v3nm v4nm];
[otpt] = LagrangeInterpolation2Dscalar(x, y, gridx, gridy, gridz);

