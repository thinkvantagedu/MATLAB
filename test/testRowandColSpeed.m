clear; clc;
n = 10000000;
a = ones(n, 10);
b = ones(10, n);

tic
for i = 1:n
    c = a(i);
end
toc

tic
for i = 1:n
    d = b(i);
end
toc