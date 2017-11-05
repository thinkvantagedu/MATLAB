function [U] = GSANMDuhamelsIntegral(fce_func, fce_dof, Phi, M_r, C_r, K_r, acce, dT, maxT, U0, V0)
%% initial condition does not have to be zero, suitable for all conditions. 
no_dof = length(M_r);
no_t_step = length((0:dT:maxT));

%% one extra time step is needed for superposition. Needs to know which dof in order to apply impulse.
fce = sparse(no_dof, 1);
fce(fce_dof) = fce(fce_dof)+1;
F_init = sparse(no_dof, no_t_step+1);
F_init(:, 1) = F_init(:, 1)+fce;
F_step = sparse(no_dof, no_t_step+1);
F_step(:, 2) = F_step(:, 2)+fce;
%% initial step and after needs to be distingushed.
[U_init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F_init, acce, dT, maxT, U0, V0);
[U_step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F_step, acce, dT, maxT, U0, V0);


U = zeros(2, no_t_step);
for i_f = 1:no_t_step
    if i_f == 1
        U = U+U_init*fce_func(1);
    elseif i_f > 1
        U_imp = ([zeros(2, i_f-2), U_step(:, 1:(no_t_step-i_f+2))]);
        U = U+U_imp*fce_func(i_f);
    end
    
end
