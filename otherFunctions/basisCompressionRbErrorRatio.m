function [otpt, nBasis] = basisCompressionRbErrorRatio...
    (inpt, reducedVar, reductionRatio)
% this function iteratively add basis vectors (left singular vectors)
% until the error (u - \phi\alpha) reduction ratio is satisfied.

[u, ~, ~] = svd(inpt, 0);
nBasis = 1;














end