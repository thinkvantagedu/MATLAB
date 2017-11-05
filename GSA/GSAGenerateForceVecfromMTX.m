function [fce_vec] = GSAGenerateForceVecfromMTX(phi, mtx)
%% generate force vector for each matrix, length of force vector = no.rb*no.dof
no_rb = size(phi, 2);
no_dof = length(mtx);

fce_vec = zeros(no_rb*no_dof, 1);

for i_rb_vec = 1:no_rb
    
    fce_single = mtx*phi(:, i_rb_vec);
    fce_vec((i_rb_vec-1)*no_dof+1:i_rb_vec*no_dof, :) = ...
        fce_vec((i_rb_vec-1)*no_dof+1:i_rb_vec*no_dof, :)+...
        fce_single;
    
end