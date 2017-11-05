clear variables; clc;
a = rand(10000, 125);


tic
c = sum(a(:).^2);
toc

tic
b = a(:);
d = b'*b;
toc