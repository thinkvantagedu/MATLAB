function [globalM] =ABAQUSReadMTX2DOF(mtx_file)
%============== Import Stiffness Matrix ==============%
% mtx_file = '/home/xiaohan/Desktop/Temp/FE_model/FE_L9H2_dynamics_I11_I20_IS0_STIF1.mtx';
ASM = dlmread(mtx_file);
ndof_per_node=2;
Node_n = max(ASM(:,1));    %or max(ASM(:,3))
ndof=Node_n*ndof_per_node;

%%
for ii=1:size(ASM,1)
    indI(ii) = ndof_per_node*(ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = ndof_per_node*(ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI,indJ,ASM(:,5),ndof,ndof);

globalM=M'+M;

for i_tran=1:length(M)
    globalM(i_tran,i_tran)=globalM(i_tran,i_tran)/2;
end