function [coeff_assemb_K] = NewmarkAssembleGlobalK(coeff_MTX_K, no_t_step, no_dof)
% create diagonal block matrix with block K on diagonal line.

coeff_assemb_K = sparse(3*no_dof*(no_t_step-1), 3*no_dof*(no_t_step-1));
for i_coef = 1:no_t_step-1
    
    coeff_assemb_K((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
        coeff_assemb_K((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
        coeff_MTX_K;
end