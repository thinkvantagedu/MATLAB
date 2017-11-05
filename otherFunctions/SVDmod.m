function [Phi, Sigma, rVec] = SVDmod(Snap, NPhi)


[Phi, Sigma1, rVec] = svd(Snap, 0);
Sigma = sparse(Sigma1);
Phi = Phi(:,1:NPhi);
Sigma = Sigma(1:NPhi, 1:NPhi);
rVec = rVec(:, 1:NPhi);