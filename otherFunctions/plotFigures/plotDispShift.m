clear; clc; clf;
% this script plot the shift of displacements.

nd = 30;
nt = 10;

% plot the matrix case.
dismtx = rand(nd, nt);
dismtx(1:2, :) = 0;
dismtx(end - 1:end, :) = 0;
disMtxStore = cell(nt, 1);

for i = 1:nt
    
    disz = zeros(nd, i - 1);
    disnz = dismtx(:, 1:(nt - i + 1));
    dismtxshift = [disz disnz];
    disMtxStore{i} = dismtxshift;
    
end
disMtxStore = cell2mat(disMtxStore);
subplot(1, 2, 1)
spy(disMtxStore, 'k')
axis square
grid minor

set(gca,'xticklabel',[]) 
set(gca,'yticklabel',[]) 
xlabel('')

% plot the vector case
disvec = dismtx(:);
disVecStore = zeros(nd * nt, nt);

for i = 1:nt
    
    disz = zeros((i - 1) * nd, 1);
    disnz = disvec(1:nd * (nt - i + 1));
    disvecshift = [disz; disnz];
    disVecStore(:, i) = disVecStore(:, i) + disvecshift;
    
end
subplot(1, 2, 2)
spy(disVecStore, 'k')
axis square
grid minor

set(gca,'xticklabel',[]) 
set(gca,'yticklabel',[]) 
xlabel('')

