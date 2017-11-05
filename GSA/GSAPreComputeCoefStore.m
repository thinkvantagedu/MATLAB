function [resp_coef_init_local, resp_coef_step_local] = GSAPreComputeCoefStore...
    (i_m_rb, no_dof, no_t_step, no_pre, imp_store, imp_loc_init, imp_loc_step, ...
    pm_pre_val_block, pm_fix_I3, phi_ident, MTX_M, MTX_C, MTX_K_I1120S0, MTX_K_I1021S0, MTX_K_I1020S1, ...
    NMcoef, time_step, time_max, Dis, Vel)
%% For EACH single RB vector, compute exact solution at interpolation points, 
%% store them (size=(no.pre*no.dof)), 
%% then put in Lag to get coefficients for interpolation. 
%% Resulting coefficients have same size as exact solutions (no.pre*no.dof).
%% 
imp_init = zeros(no_dof, no_t_step);
imp_step = zeros(no_dof, no_t_step);

imp_vec = imp_store(:, i_m_rb);

imp_init(:, imp_loc_init) = imp_init(:, imp_loc_init)+imp_vec;
imp_step(:, imp_loc_step) = imp_step(:, imp_loc_step)+imp_vec;

resp_store_init_local = zeros(no_pre*no_dof, no_t_step);
resp_store_step_local = zeros(no_pre*no_dof, no_t_step);
%%
for i_m_pre = 1:no_pre
    
    MTX_K = MTX_K_I1120S0*pm_pre_val_block(i_m_pre, 1)+...
        MTX_K_I1021S0*pm_pre_val_block(i_m_pre, 2)+MTX_K_I1020S1*pm_fix_I3;
    %%
    [~, ~, ~, resp_init, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi_ident, MTX_M, MTX_C, MTX_K, ...
        imp_init, NMcoef, time_step, time_max, Dis, Vel);
    
    resp_store_init_local((i_m_pre-1)*no_dof+1:i_m_pre*no_dof, :) = ...
        resp_store_init_local((i_m_pre-1)*no_dof+1:i_m_pre*no_dof, :)+resp_init;
    %%
    [~, ~, ~, resp_step, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
        (phi_ident, MTX_M, MTX_C, MTX_K, ...
        imp_step, NMcoef, time_step, time_max, Dis, Vel);
    
    resp_store_step_local((i_m_pre-1)*no_dof+1:i_m_pre*no_dof, :) = ...
        resp_store_step_local((i_m_pre-1)*no_dof+1:i_m_pre*no_dof, :)+resp_step;
    
end
%%
resp_coef_init_local = LagInterpolationCoeff(pm_pre_val_block, resp_store_init_local);
resp_coef_step_local = LagInterpolationCoeff(pm_pre_val_block, resp_store_step_local);