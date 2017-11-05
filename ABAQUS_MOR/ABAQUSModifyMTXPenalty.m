function [modified_MTX]=ABAQUSModifyMTXPenalty(MTX_file, cons, node)
%%
% Modify MTX penalty coefficient to 10^5 larger than the largest MTX value.
% cons and node are imported from INP.
%%
% test
% MTX_file=MTX_K_full;
%%
MTX_file1=MTX_file;
dof=node(:, 1);
dof(cons, :)=[];
free_dof=zeros(1, 3*length(dof));
for i_dof=1:length(dof)
    
   dof_1=(3*dof(i_dof)-2):(3*dof(i_dof));
   free_dof(1, 3*i_dof-2:3*i_dof)=free_dof(1, 3*i_dof-2:3*i_dof)+dof_1;
    
end

MTX_file1=MTX_file1(free_dof, free_dof);

max_val=max(MTX_file1(:));

penalty_val=max_val*10^5;

full_cons=zeros(3*length(cons), 1);

for i_fulcon=1:length(cons)
   
    full_cons(3*i_fulcon-2:3*i_fulcon, :)=...
        full_cons(3*i_fulcon-2:3*i_fulcon, :)+...
        (3*cons(i_fulcon)-2:3*cons(i_fulcon))';
    
end

MTX_file(full_cons, full_cons)=penalty_val; 

modified_MTX=MTX_file;