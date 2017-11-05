function [otpt] = sumDiagSqMTXAll(inpt)

% this function sums all diagonal elemets of a square matrix, not just the
% main diagonal.

n = length(inpt);

a = (1:1:n)';

b = (n-1:-1:0);

% subsidx denotes the index relation between val and subs in accumarray.
idxsubs = bsxfun(@plus, a, b);

subs = reshape(idxsubs, [], 1);

diagsum = @(x) accumarray(subs, x);

otpt = diagsum(inpt(:));