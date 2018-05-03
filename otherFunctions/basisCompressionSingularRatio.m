function [otpt, singularRatio, nBasis] = ...
    basisCompressionSingularRatio(inpt, reductionRatio)
% this function iteratively add basis vectors (left singular vectors) 
% until the error (singular values) reduction ratio is satisfied.
% [otpt, singularRatio, nBasis] = ...
% basisCompressionSingularRatio(inpt, reductionRatio)

[u, s, ~] = svd(inpt, 0);
nBasis = 1;
% sum of all singular values^2 then take square root.
sDiag = diag(s);
sSum = sqrt(sum(sDiag .^ 2));
for iS = 1:length(sDiag)
    
    ss = sqrt(sum(sDiag(1:iS) .^ 2));
    singularRatio = ss / sSum;
    if singularRatio < reductionRatio
        nBasis = nBasis + 1;
    elseif singularRatio >= reductionRatio
        break
    end

end

otpt = u(:, 1:nBasis);

end
