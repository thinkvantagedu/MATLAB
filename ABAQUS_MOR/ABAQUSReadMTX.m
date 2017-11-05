function [globalM] =ABAQUSReadMTX(mtx_file)
%============== Import Stiffness Matrix ==============%

ASM = dlmread(mtx_file);
ndof_per_node=3;
Node_n = max(ASM(:,1));    %or max(ASM(:,3))
ndof=Node_n*ndof_per_node;

%%%% Replace the 6 in col 2 and 4 with 3
replace_M=[3, 6];
ntmp1= ASM(:,2)==replace_M(2);  ntmp2= ASM(:,4)==replace_M(2);
ASM(ntmp1,2)=replace_M(1); ASM(ntmp2,4)=replace_M(1);

for ii=1:size(ASM,1)
    indI(ii) = ndof_per_node*(ASM(ii,1)-1) + ASM(ii,2);
    indJ(ii) = ndof_per_node*(ASM(ii,3)-1) + ASM(ii,4);
end

M = sparse(indI,indJ,ASM(:,5),ndof,ndof);



globalM=M'+M;
for i_tran=1:length(M)
    globalM(i_tran,i_tran)=globalM(i_tran,i_tran)/2;
end