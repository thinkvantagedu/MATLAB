clear variables; clc;

project = @(x, y) x' * y * x;

a = rand(5, 2);

b = rand(5, 5);

c = project(a, b);