function [f_t] = NewmarkAssembleGlobalForce(fce, dT, no_dof, no_t_step, acce, A0, V0, U0)
% assemble force vector from time-dependent force function, result in a
% form of [F1 0 0 F2 0 0 ......]', number of F equals to no_t_step-1.

switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; 
    case 'linear'
        beta = 1/6; gamma = 1/2;
end

a3 = (1-gamma)*dT;
a5 = (beta-0.5)*dT^2;

f_t = sparse(3*no_dof*(no_t_step-1), 1);

f_ini = [fce(:, 2); -a3*A0-V0; a5*A0-V0-U0];

f_add = sparse(2*no_dof, 1);

for i_coef = 1:no_t_step-1
    
    f_t((i_coef-1)*3*no_dof+1:(i_coef)*3*no_dof, :) = f_t((i_coef-1)*3*no_dof+1:(i_coef)*3*no_dof, :)+...
        [fce(:, i_coef+1); f_add];
    
end

f_t(1:3*no_dof, :) = zeros(3*no_dof, 1);
f_t(1:3*no_dof, :) = f_t(1:3*no_dof, :)+f_ini;