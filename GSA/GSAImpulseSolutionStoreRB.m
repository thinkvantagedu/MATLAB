function [dis_storerb] = GSAImpulseSolutionStoreRB...
    (imp_store, loc_imp, no_dof, no_t_step, no_rb, phi, MTX_M, MTX_C, MTX_K, ...
    NMcoeff, time_step, time_max, Dis_inpt, Vel_inpt)

dis_storerb = zeros(no_dof*no_rb, no_t_step);

for i_imp = 1:no_rb
    %%
    imp_vec = imp_store(:, i_imp);
    imp = zeros(no_dof, no_t_step);
    imp(:, loc_imp) = imp(:, loc_imp)+imp_vec;
    
    [~, ~, ~, dis_imp, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi, MTX_M, MTX_C, MTX_K, imp, NMcoeff, time_step, time_max, Dis_inpt, Vel_inpt);
    
    dis_storerb((i_imp-1)*no_dof+1:i_imp*no_dof, :) = ...
        dis_storerb((i_imp-1)*no_dof+1:i_imp*no_dof, :)+dis_imp;
    
end