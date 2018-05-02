function [otpt, singularRatio] = basisCompressionRatio(inpt, reductionRatio)
% this function iteratively add basis vectors (left singular vectors) 
% until the error reduction ratio is satisfied.

[u, s, ~] = svd(inpt, 0);
no = 1;
% sum of all singular values^2 then take square root.
sDiag = diag(s);
sSum = sqrt(sum(sDiag .^ 2));
for iS = 1:length(sDiag)
    
    ss = sqrt(sum(sDiag(1:iS) .^ 2));
    singularRatio = ss / sSum;
    if singularRatio < reductionRatio
        no = no + 1;
    elseif singularRatio >= reductionRatio
        break
    end

end

otpt = u(:, 1:no);

end