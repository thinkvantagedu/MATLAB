clear; clc;
% test interpolation with scalars, vectors and matrices. scalars are in
% vectors, vectrors are in matrices. 
xl = 0;
xr = 2;
yl = 0;
yr = 2;
x = 1;
y = 1;
[gridx, gridy] = meshgrid([xl, xr], [yl, yr]);

% scalar case, the z-grid is made of scalars.
gridz = [1 -2; 2 4];
[otptscalar] = LagrangeInterpolation2Dscalar(x, y, gridx, gridy, gridz);

% vector case, the z-grid is made of vectors, first element of vectors
% contains scalars in scalar case. 

a1 = (1:4)';
a2 = a1 + 1;
a3 = a1 - 3;
a4 = a1 + 3;

a = {a1 a2; a3 a4};

[otptvector] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, a);

% matrix case, the z-grid is made of matrices, first vector of matrices
% contains vectors in vector case. 

a1m = [1:4; 2:5; 4:7]';
a2m = a1m + 1;
a3m = a1m - 3;
a4m = a1m + 3;

am = {a1m a2m; a3m a4m};

[otptmatrix] = LagrangeInterpolation2Dmatrix(x, y, gridx, gridy, am);

% conclusion: interpolation of matrices contains vectors; interpolation of
% vectors contains scalars. 