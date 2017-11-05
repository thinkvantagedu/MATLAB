function [coef_asmb, F_t, U_r, V_r, A_r, U, V, A, time, no_t_step] = NewmarkBetaReducedMethodAssembleINI...
    (phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0)

% solve Newmark in one giant step, initial matrix block is assembled
% following Pierre's method. 

% clear variables; clc;
% %%
% phi=eye(2);
% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% %%
% dT=0.28;
% maxT=2.8;
% U0=[0; 0];
% V0=[0; 0];
% acce='average';
%%
switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end
no_dof = length(M_r);
coef_idn = eye(no_dof);
no_rb = size(phi, 2);
%%
time = 0:dT:(maxT);
no_t_step = length(time);
%%
% F_r=zeros(no_dof, no_t_step);
% for i_f0=1:no_t_step        
%     F_r(:, i_f0)=F_r(1:2, i_f0)+[0; 10];
% end
%%
A0 = M_r\(F_r(:, 1)-C_r*V0-K_r*U0);
Q_ini = [A0; V0; U0];
Q_r_col = zeros(3*no_dof*no_t_step, 1);
Q_r_col(1:3*no_dof, :) = Q_r_col(1:3*no_dof, :)+Q_ini;
Q_r_row = zeros(3*no_dof, no_t_step);
%%
a1 = gamma*dT;
a2 = beta*dT^2;
a3 = (1-gamma)*dT;
a4 = (1/2-beta)*dT^2;
a5 = (beta-0.5)*dT^2;

coef_MTX_ini = [M_r C_r K_r; 0*coef_idn coef_idn 0*coef_idn; 0*coef_idn 0*coef_idn coef_idn];
coef_MTX_A = [M_r C_r K_r; a1*coef_idn -coef_idn 0*coef_idn; a2*coef_idn 0*coef_idn -coef_idn];
coef_MTX_B = [0*coef_idn 0*coef_idn 0*coef_idn; a3*coef_idn coef_idn 0*coef_idn; a4*coef_idn dT*coef_idn coef_idn];
coef_asmb = sparse(3*no_dof*(no_t_step), 3*no_dof*(no_t_step));

%%
F_t = sparse(3*no_dof*(no_t_step), 1);
F_ini = [F_r(:, 1); V0; U0];
F_add = sparse(2*no_dof, 1);

%%
for i_coef = 1:no_t_step
    if i_coef == 1
        coef_asmb(1:3*no_dof, 1:3*no_dof) = coef_asmb(1:3*no_dof, 1:3*no_dof)+coef_MTX_ini;
    else
        coef_asmb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
            coef_asmb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
            coef_MTX_A;
        F_t((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, :) = F_t((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, :)+...
            [F_r(:, i_coef); F_add];
    end
end

for i_coef = 1:no_t_step-1
    
   coef_asmb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
        coef_asmb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
        coef_MTX_B; 
    
end

F_t(1:3*no_dof, :) = zeros(3*no_dof, 1);
F_t(1:3*no_dof, :) = F_t(1:3*no_dof, :)+F_ini;

Q_r_col = Q_r_col+coef_asmb\F_t;

%%
for i_t = 1:no_t_step
    
    Q_r_row(:, i_t) = Q_r_row(:, i_t)+Q_r_col((i_t-1)*no_dof*3+1:i_t*no_dof*3);
    
end
A_r = Q_r_row(1:no_rb, :);
V_r = Q_r_row(no_rb+1:2*no_rb, :);
U_r = Q_r_row(2*no_rb+1:3*no_rb, :);
%%
Q_row = zeros(3*length(phi), no_t_step);
for i = 1:3
    
    Q_row((i-1)*length(phi)+1:i*length(phi), :) = Q_row((i-1)*length(phi)+1:i*length(phi), :)+...
        phi*Q_r_row((i-1)*no_dof+1:i*no_dof, :);
    
end

A = Q_row(1:no_dof, :);
V = Q_row(no_dof+1:2*no_dof, :);
U = Q_row(2*no_dof+1:3*no_dof, :);