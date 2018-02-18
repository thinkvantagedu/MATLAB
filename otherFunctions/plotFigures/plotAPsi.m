% this script plots \bA \bPsi, run callFixie first. 
% generate \bA;
clf;
ntake = 2;
M = fixie.mas.mtx(1:ntake, 1:ntake);
C = fixie.dam.mtx(1:ntake, 1:ntake);
K = fixie.sti.full(1:ntake, 1:ntake);
acce = 'average';
dT = 0.1;
maxT = 1.1;
[coef_asmb] = NewmarkBetaReducedMethodAssembleSysMTX(M, C, K, acce, dT, maxT);

% generate corresponding \bPsi. 
phi = fixie.phi.val(1:ntake, :);

nblk = (maxT / dT + 1) * 3;
phiz = zeros(size(phi));
phiB = cell(nblk, nblk);
for  i = 1:nblk
    for j = 1:nblk
        if i == j
            phiB(i, j) = {phi(:, 1)};
        else
            phiB(i, j) = {phiz(:, 1)};
        end
    end
end
phiM = cell2mat(phiB);

% multiply the terms and plot.
APsi = coef_asmb * phiM;

figure(1)
spy(coef_asmb, 2, 'r')
axis square
xlabel('')
grid minor
set(gcf, 'Color', [1,1,1]);

figure(2)
spy(phiM, 2, 'g')
axis([0 size(phiM, 2) + 1 0 size(phiM, 1) + 1])
xlabel('')
grid minor
set(gcf, 'Color', [1,1,1]);

figure(3)
spy(APsi, 2, 'k')
axis([0 size(phiM, 2) + 1 0 size(phiM, 1) + 1])
xlabel('')
grid minor
set(gcf, 'Color', [1,1,1]);