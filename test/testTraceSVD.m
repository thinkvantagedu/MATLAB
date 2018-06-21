clear; clc;
% this script tests what's the fastest way to compute trace with SVD
% vectors.
ma = rand(30000, 100);
mb = rand(30000, 100);

[ua, sa, va] = svd(ma, 0);
[ub, sb, vb] = svd(mb, 0);

tic
for i = 1:1000
    otptTr = trace((vb' * va) * sa' * (ua' * ub) * sb);
end
toc
tic
for i = 1:1000
    otptSum = sum(sum(((vb' * va) * sa') .* ((ua' * ub) * sb)', 2));
end
toc
