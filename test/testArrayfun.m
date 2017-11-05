clear variables; clc;

a = rand(5);

b = rand(5);

c = rand(5);

% [d] = testArrayfunFunc(a, b, c);
% 
% [e] = arrayfun(@testArrayfunFunc, a, b, c);

f = @(x, y, z) 3*x + y.^2 - sin(z);

d = arrayfun(f, a, b, c);