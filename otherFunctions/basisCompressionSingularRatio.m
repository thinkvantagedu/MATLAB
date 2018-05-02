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

pmMax = obj.pmVal.max;
M = obj.mas.mtx;
C = obj.dam.mtx;
K = obj.sti.mtxCell;
F = obj.fce.val;
dt =
% generate initial basis.
nAdd = 1;
phiPre = obj.phi.val;
for i = 1:obj.no.dof
    
    phiOtpt = [phiPre rbEnrich(:, 1:nAdd)];
    m = phiOtpt' * M * phiOtpt;
    c = phiOtpt' * C * phiOtpt;
    kCell = cellfun(@(v) phiOtpt' * v * phiOtpt, K, 'un', 0);
    k = kCell{1} * pmMax + kCell{2} * obj.pmVal.s.fix;
    f = phiOtpt' * F;
    [rv, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phiOtpt, m, c, k, f, 'average', dT, maxT, U0, V0);