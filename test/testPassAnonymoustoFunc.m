clear; clc;

proj = @(x, y) x' * y * x;
x = 1;
y = 2;
[otpt] = funcTestPassAnonymoustoFunc(proj, x, y);