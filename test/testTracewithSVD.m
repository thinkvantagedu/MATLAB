clear; clc;
% this script tests how to calculate trace with vectors and SVD applied.

a = [1 2 3 4; 4 2 6 3; 3 1 5 7];
[ua, sa, va] = svd(a, 0);

b = [1 3 5 7; 2 3 8 6; 9 8 6 8];
[ub, sb, vb] = svd(b, 0);

tratb = trace(a' * b);

trvec = 0;

for i = 1:4
    
    trvec = trvec + a(:, i)' * b(:, i);
    
end

trsvd = trace((vb' * va) * sa' * (ua' * ub) * sb);

trsep = 0;

for i = 1:3
    
    trsep = trsep + ...
        trace((ua(:, i) * sa(i, i) * va(:, i)')' * ...
        (ub(:, i) * sb(i, i) * vb(:, i)'));
    
end