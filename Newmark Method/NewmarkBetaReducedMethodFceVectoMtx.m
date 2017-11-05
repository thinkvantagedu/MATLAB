function [U, V, A] = NewmarkBetaReducedMethodFceVectoMtx(Q_vec, no_t_step, no_dof)

Q_row = zeros(3*no_dof, no_t_step);

for i_t = 1:no_t_step
    
    Q_row(:, i_t) = Q_row(:, i_t)+Q_vec((i_t-1)*no_dof*3+1:i_t*no_dof*3);
    
end

A = Q_row(1:no_dof, :);
V = Q_row(no_dof+1:2*no_dof, :);
U = Q_row(2*no_dof+1:3*no_dof, :);