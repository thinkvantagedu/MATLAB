% this script test assemble m, c, k in Hs, 
% case 1. multiply Psi matrix, then multiply rvCol
% case 2. multiply Psi vector (reshaped), then .* rvCol.
% is case 1 and case 2 equivalent?

% the psi matrix should contain single basis vector in this case.

m = canti.mas.mtx;
c = canti.dam.mtx;
k = canti.sti.full;

nd = canti.no.dof;
nt = 2;

mtxi = ones(nd, nd);
mtxz = zeros(nd, nd);
Hs = [m c k; mtxz mtxi mtxz; mtxz mtxz mtxi];
Hz = zeros(length(Hs), length(Hs));

A = [Hs Hz; Hz Hs];

phi = canti.phi.val;
phiz = zeros(size(phi, 1), size(phi, 2));

rv = (1:size(phi, 2) * nt * 3)';

%% case 1: use matrix, which is the theory.
mtxphi = cell(3 * nt, 3 * nt);
for i = 1:3 * nt
    for j = 1:3 * nt
        if i == j
            mtxphi(i, j) = {phi};
        else
            mtxphi(i, j) = {phiz};
        end
    end
end
        
mtxphi = cell2mat(mtxphi);

res1 = A * mtxphi * rv;

%% case 2: use vector, need entrywise product.
vecphi = cell(3 * nt, 1);
for i = 1:length(vecphi)
    vecphi(i) = {phi};
end

vecphi = cell2mat(vecphi);

res2cell = A * vecphi;
res2cell = mat2cell(res2cell, 12 * ones(6, 1), 1);
res2 = cell(6, 1);
for i = 1:6
    res2{i} = res2cell{i} * rv(i);
end
res2 = cell2mat(res2);
% conclusion: cannot reshape phi matrix into phi vectors, dimension won't
% match, even brutally matched, results are not the same (res1 and res2).