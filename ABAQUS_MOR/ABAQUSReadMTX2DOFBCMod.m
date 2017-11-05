function [globalMBC] =ABAQUSReadMTX2DOFBCMod(mtx_file, cons, no_dof)
%============== Import Stiffness Matrix and modify with BC==============%
% mtx_file = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I11_I20_IS0_STIF1.mtx';
ASM = dlmread(mtx_file);
ndof_per_node = 2;
Node_n = max(ASM(:,1));    %or max(ASM(:,3))
ndof = Node_n * ndof_per_node;

%%
for ii=1:size(ASM,1)
    indI(ii) = ndof_per_node * (ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = ndof_per_node * (ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI,indJ,ASM(:,5), ndof, ndof);

globalMBC = M' + M;

for i_tran = 1 : length(M)
    globalMBC(i_tran,i_tran) = globalMBC(i_tran, i_tran) / 2;
end

diagindx = (cons - 1) * (no_dof + 1) + 1;

globalMBC(cons, :) = 0;

globalMBC(:, cons) = 0;

globalMBC(diagindx) = 1;
