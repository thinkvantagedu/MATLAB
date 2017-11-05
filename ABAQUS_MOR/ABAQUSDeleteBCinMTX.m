function [deleted_Matrix]=ABAQUSDeleteBCinMTX(Matrix_Origin, cons, node)
%%
% Delete fixed rows and cols in matrix
%%
% test
% MTX_file=MTX_K_full;
%%
dof=node(:, 1);
dof(cons, :)=[];
free_dof=zeros(1, 3*length(dof));
for i_dof=1:length(dof)
    
   dof_1=(3*dof(i_dof)-2):(3*dof(i_dof));
   free_dof(1, 3*i_dof-2:3*i_dof)=free_dof(1, 3*i_dof-2:3*i_dof)+dof_1;
    
end

deleted_Matrix=Matrix_Origin(free_dof, free_dof);