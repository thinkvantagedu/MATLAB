function [phi_asemb] = GSAAssemblePhi(phi, no_dof, no_t_step)

phi_asemb = sparse(3*no_dof*(no_t_step-1), size(phi, 2)*3*(no_t_step-1));

for i_phi = 1:(no_t_step-1)*3
    
    phi_asemb((i_phi-1)*no_dof+1:i_phi*no_dof, (i_phi-1)*size(phi, 2)+1:i_phi*size(phi, 2)) = ...
        phi_asemb((i_phi-1)*no_dof+1:i_phi*no_dof, (i_phi-1)*size(phi, 2)+1:i_phi*size(phi, 2))+...
        phi;
    
end