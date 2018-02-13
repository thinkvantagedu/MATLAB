clear; clc;

phiDemo = ones(2, 2);
phiAsemb = cell(36, 36);
phiZ = zeros(2, 2);

for i = 1:36
    for j = 1:36
        if i == j
            phiAsemb{i, j} = phiDemo;
        else 
            phiAsemb{i, j} = phiZ;
        end
    end
end

phiAsemb = cell2mat(phiAsemb);

rv = ones(66, 1);
rv(25:42) = 0;
spy(rv, 'k')
set(gca, 'xtick', [])
set(gca, 'ytick', [])