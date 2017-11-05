clear variables; clc;

a = rand(5, 6);
a0 = a(2:4, 2:4);

b = rand(5, 6);
b0 = b(2:4, 2:4);

c = rand(5, 6);
c0 = c(2:4, 2:4);

d = rand(5, 6);
d0 = d(2:4, 2:4);

xy = [1 1; 1 2; 2 1; 2 2];

z = [a; b; c; d];

z0 = [a0; b0; c0; d0];

coeff = LagInterpolationCoeff(xy, z);

coeff0 = LagInterpolationCoeff(xy, z0);

x = 1.5; y = 1.5;

[lag_val] = LagInterpolationOtptSingle(coeff, x, y, 4);

[lag_val0] = LagInterpolationOtptSingle(coeff0, x, y, 4);