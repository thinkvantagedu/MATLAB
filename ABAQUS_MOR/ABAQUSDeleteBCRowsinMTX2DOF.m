function [rows_deleted_Matrix]=ABAQUSDeleteBCRowsinMTX2DOF(Matrix_Origin, cons, node)
%%
% Delete fixed rows and cols in matrix
%%
% test
% MTX_file=MTX_K_full;
%%
dof=node(:, 1);
dof(cons, :)=[];
free_dof=zeros(1, 2*length(dof));
for i_dof=1:length(dof)
    
   dof_1=(2*dof(i_dof)-1):(2*dof(i_dof));
   free_dof(1, 2*i_dof-1:2*i_dof)=free_dof(1, 2*i_dof-1:2*i_dof)+dof_1;
    
end

rows_deleted_Matrix=Matrix_Origin(free_dof, :);