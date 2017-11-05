function [f_vec] = NewmarkBetaReducedMethodAssembleForceVector(f, dT, maxT)

%% aassemble force vector for giant Newmark solution. 

no_dof = size(f, 1);
no_t_step = length(0:dT:maxT);

f_vec = sparse(3*no_dof*(no_t_step), 1);
f_add = sparse(2*no_dof, 1);

for i_coef = 1:no_t_step
    
    f_vec((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, :) = f_vec((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, :)+...
            [f(:, i_coef); f_add];
    
end