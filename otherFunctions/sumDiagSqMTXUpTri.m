function [otpt] = sumDiagSqMTXUpTri(inpt)

% THIS FUNCTION IS SLOWER THAN sumDiagSqMTXAll, DO NOT USE! this function sums the upper diagonal elements of a square matrix, not
% just the main diagonal.  

n = length(inpt);

a = (1:1:n)';

b = (n-1:-1:0);

% subsidx denotes the index relation between val and subs in accumarray.
idxsubs = bsxfun(@plus,a,b);

subs = reshape(idxsubs,[],1);

% find the upper triangular index of square matrix.
idxuptri = find(triu(ones(n)));
% find subs elements related to upper triangular indices.
idxsubsuptri = subs(idxuptri);
% find inpt elements related to upper triangular indices.
inptuptri = inpt(idxuptri);

diagsum = @(subs, x) accumarray(subs, x);

otpt = diagsum(idxsubsuptri, inptuptri);