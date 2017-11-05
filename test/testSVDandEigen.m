clear variables; clc;

a = rand(5);

[a1, a2, a3] = svd(a);

[a4, a5] = eig(a);