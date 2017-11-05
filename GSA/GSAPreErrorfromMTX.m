function [Dis_lag_store_glob_mtx] = GSAPreErrorfromMTX(no_pre, no_dof, no_t_step, no_rb, time_aply_step,...
    pm_block, pm_I3, lod_vec_asemb, MTX_K_I1120S0, MTX_K_I1021S0, MTX_K_I1020S1, phi_ident, MTX_M, MTX_C, ...
    NMcoeff, time_step, time_max, Dis_inpt, Vel_inpt)

% compute no.pre times displacements first, then assemble
% for each rb, therefore no.pre being computed first, no.rb being computed after.
% This is very important for deciding interpolation first or multiplying
% alpha first. For this case, it's interpolation first.

%% pre-error from mtx
Dis_lag_store_local_mtx = zeros(no_pre*no_dof, no_t_step);
Dis_lag_store_glob_mtx = zeros(no_rb*no_pre*no_dof, no_t_step);

for i_rb = 1:no_rb
    lod = zeros(no_dof, no_t_step);
    %% assemble force function.
    lod(:, time_aply_step) = lod(:, time_aply_step)+...
        lod_vec_asemb((i_rb-1)*no_dof+1:i_rb*no_dof);
    
    %% for each force function, obtain no_pre displacements.
    for i_lag = 1:no_pre
        
        MTX_K = MTX_K_I1120S0*pm_block(i_lag, 1)+...
            MTX_K_I1021S0*pm_block(i_lag, 2)+...
            MTX_K_I1020S1*pm_I3;
        [Dis_lag_val_mtx, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
            (phi_ident, MTX_M, MTX_C, MTX_K, lod, NMcoeff, time_step, time_max, Dis_inpt, Vel_inpt);
        %% store displacements locally for no_pre times.
        Dis_lag_store_local_mtx((i_lag-1)*no_dof+1:i_lag*no_dof, :) = ...
            Dis_lag_store_local_mtx((i_lag-1)*no_dof+1:i_lag*no_dof, :)+...
            Dis_lag_val_mtx;
        
    end
    %% store displacements globally for no_rb times. size = (no_dof*no_rb*no_pre, no_t_step).
    Dis_lag_store_glob_mtx((i_rb-1)*no_pre*no_dof+1:i_rb*no_pre*no_dof, :) = ...
        Dis_lag_store_glob_mtx((i_rb-1)*no_pre*no_dof+1:i_rb*no_pre*no_dof, :)+...
        Dis_lag_store_local_mtx;
end