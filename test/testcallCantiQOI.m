clear; clc;

a = magic(10000);

at = triu(a);

b = rand(10000);

bt = triu(b);

% at(:, 1:9000) = 0;
at = sparse(at);
bt = sparse(bt);
tic

c = a .* b;

toc 

tic

ct = at .* bt;

toc