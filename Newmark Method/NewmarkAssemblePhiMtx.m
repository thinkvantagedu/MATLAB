function [phi_asmb] = NewmarkAssemblePhiMtx(phi, no_dof, no_t_step)

no_rb = size(phi, 2);

phi_asmb = sparse(3*no_dof*no_t_step, 3*no_rb*no_t_step);

for i_p = 1:(3*no_t_step)
    
   phi_asmb((i_p-1)*no_dof+1:i_p*no_dof, (i_p-1)*no_rb+1:i_p*no_rb) = ...
       phi_asmb((i_p-1)*no_dof+1:i_p*no_dof, (i_p-1)*no_rb+1:i_p*no_rb)+phi;
    
end