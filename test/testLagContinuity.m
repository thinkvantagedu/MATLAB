clear variables; clc;

a1 = [1 2; 3 4];
a2 = [5 6; 7 8];
a3 = [2 3; 4 5];
a4 = [3 4; 6 7];
a5 = [1 3; 5 7];
a6 = [2 4; 6 8];

block1 = [1 1; 1.5 1; 1.5 1.5; 1 1.5];

block2 = [1.5 1; 2 1; 2 1.5; 1.5 1.5];

coeff1 = LagInterpolationCoeff(block1, [a1; a2; a3; a4]);

coeff2 = LagInterpolationCoeff(block2, [a2; a5; a6; a3]);

otpt1 = LagInterpolationOtptSingle(coeff1, 1.5, 1, 4);

otpt2 = LagInterpolationOtptSingle(coeff2, 1.5, 1, 4);
