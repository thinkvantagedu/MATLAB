clear variables; clc;
xy = [1 1; 1 2; 2 1; 2 2];
z = [1 2; 3 4; 2 3; 4 5; 1 3; 5 7; 2 4; 6 8];
% xy = [1 1; 1 5; 1 10; 5 1; 5 5; 5 10; 10 1; 10 5; 10 10];
% z.val = [1 2; 2 1; 2 3; 3 1; 1 3; 2 2; 3 2; 1 1; 2 4; 3 3; 3 1; 2 2; 1 2; 3 4; 2 2; 4 1; 1 3; 2 4];
% z.val = [6; 3; 4; 2; 1; 3; 5; 2; 6];
% test symmetric samples, are coeff also symmetric? Yes coeff are also
% symmetric, thus save half?
% z.val = [1 2 3; 2 5 6; 3 6 7; 2 3 4; 3 6 5; 4 5 2; 3 4 5; 4 6 2; 5 2 1; 4 5 6; 5 1 3; 6 3 2];
[coeffStore] = LagInterpolationCoeff(xy, z);

xy1 = [1 2; 1 3; 2 2; 2 3];
z1 = [2 3; 4 5; 6 8; 9 7; 2 4; 6 8; 1 5; 7 9];
[coeffStore1] = LagInterpolationCoeff(xy1, z1);

x = 1.5;
y = 2;
np = 4;
otpt = LagInterpolationOtptSingle(coeffStore, x, y, np);
otpt1 = LagInterpolationOtptSingle(coeffStore1, x, y, np);
