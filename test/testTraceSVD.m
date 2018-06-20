clear; clc;
% this script tests what's the fastest way to compute trace with SVD
% vectors.
ma = rand(1000, 5);
mb = rand(1000, 5);

[ua, sa, va] = svd(ma, 0);
[ub, sb, vb] = svd(mb, 0);

otptTr = trace((vb' * va) * sa' * (ua' * ub) * sb);

otptSum = sum(sum(((vb' * va) * sa')* ((ua' * ub) * sb)', 2));
