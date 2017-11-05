function [resp_otpt_init_local_qoi, resp_otpt_step_local_qoi] = GSAInterpolateRespFromCoef...
    (i_itpl, no_pre, no_dof, pm_I1, pm_I2, resp_coef_init_glob, resp_coef_step_glob, ...
    qoi_dof, no_qoi_dof, qoi_t_r)
%% For EACH RB, take corresponding interpolation coefficients, 
%% from no.pre coeff to interpolate 1 resulting response. Result size=(no.qoi.dof*no.t_step).

resp_coef_init_qoi = zeros(no_pre*no_qoi_dof, qoi_t_r);

% size = (no.pre*no.dof, no.t_step).
resp_coef_init_pre = ...
    resp_coef_init_glob((i_itpl-1)*no_pre*no_dof+1:i_itpl*no_pre*no_dof, :);

for i1 = 1:no_pre 
    % size = no.dof, no.t_step
    resp_coef_init_local = resp_coef_init_pre((i1-1)*no_dof+1:i1*no_dof, :);
    % size = no.qoi.dof, no.qoi.t_step
    resp_coef_init_qoi_local = resp_coef_init_local(qoi_dof, 1:qoi_t_r);
    % size = no.pre*no.qoi.dof, no.qoi.t_step
    resp_coef_init_qoi((i1-1)*no_qoi_dof+1:i1*no_qoi_dof, :) = ...
        resp_coef_init_qoi((i1-1)*no_qoi_dof+1:i1*no_qoi_dof, :)+resp_coef_init_qoi_local;
end

% size = (no.qoi.dof, no.t_step).
resp_otpt_init_local_qoi = LagInterpolationOtptSingle...
    (resp_coef_init_qoi, pm_I1, pm_I2, no_pre);

%%
% for step, not init.
resp_coef_step_qoi = zeros(no_pre*no_qoi_dof, qoi_t_r);

resp_coef_step_pre = ...
    resp_coef_step_glob((i_itpl-1)*no_pre*no_dof+1:i_itpl*no_pre*no_dof, :);

for i1 = 1:no_pre 
    resp_coef_step_local = resp_coef_step_pre((i1-1)*no_dof+1:i1*no_dof, :);
    resp_coef_step_qoi_local = resp_coef_step_local(qoi_dof, 1:qoi_t_r);
    resp_coef_step_qoi((i1-1)*no_qoi_dof+1:i1*no_qoi_dof, :) = ...
        resp_coef_step_qoi((i1-1)*no_qoi_dof+1:i1*no_qoi_dof, :)+resp_coef_step_qoi_local;
end

% size = (no.dof, no.t_step).
resp_otpt_step_local_qoi = LagInterpolationOtptSingle...
    (resp_coef_step_qoi, pm_I1, pm_I2, no_pre);
