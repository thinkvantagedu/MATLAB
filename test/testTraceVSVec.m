% this script tests trace(a' * b) vs using for loop with vector products,
% see which one is faster.


nd = 50000;
nt = 5000;
a = rand(nd, nt);
b = rand(nd, nt);

tic
for i = 10000
    c = trace(a' * b);
end
toc

tic
d = 0;
for i = 10000
    
    for j = 1:nt
        d = d + a(:, j)' * b(:, j);
    end
    
end
toc