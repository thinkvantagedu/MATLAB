clear; clc;
% this script tests the linear combination of matrix contains vectors.
nd = 10;
nt = 5;
nr = 4;

% generate phi, dim = nd * nr.
phi = rand(nd, nr);
phiz = zeros(nd, nr);
% generate Psi, dim = 3ndnt * 3nrnt.
Psi = cell(3 * nt, 3 * nt);
for i = 1:length(Psi)
    for j = 1:length(Psi)
        if i == j
            Psi{i, j} = phi;
        else
            Psi{i, j} = phiz;
        end
    end
end
Psi = cell2mat(Psi);

% generate alpha, dim = 3nrnt by 1;
al = rand(3 * nr * nt, 1);

% extract the rb-dependent reduced basis matrices. dim(phirbvec) = 
% 3ndnt by 3nt, dim(alpv) = 3nt by 1. Total no of rb-dependent matrices is 
% nrb. Store in cell phim.

phim = cell(nr, 1);

rowphi = zeros(nr, 3 * nt);
for i = 1:nr
    for j = 1:3 * nt
        rowphi(i, j) = i + nr * (j - 1);
    end
    phim{i} = Psi(:, rowphi(i, :));
end

% extract the rb-dependent reduced variable vectors. dim(rvrbvec) = 3nt by
% 1. Total no of rb-dependent vectors is nrb, store in cell rvv.
rvv = cell(nr, 1);

for i = 1:nr
    rvv{i} = al(rowphi(i, :));
end

% linearly combine phim and rvv. 
phimrvv = cellfun(@(u, v) u * v, phim, rvv, 'un', 0);

% Psi * alpha.
phirv = Psi * al;

phimrvvsum = sum(cat(3, phimrvv{:}), 3);

iszero = phirv - phimrvvsum;

% conclusion: Psi * rv = \sum_{r} (Psir * rvr). 