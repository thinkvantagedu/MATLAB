function [coeff_assemb] = NewmarkAssembleGlobalMTX(coeff_MTX_A, coeff_MTX_B, no_t_step, no_dof)
% assemble global coeff matrix from A_noK and B. size = 3*no_dof*no_t_step
% by 3*no_dof*no_t_step

coeff_assemb = sparse(3*no_dof*(no_t_step-1), 3*no_dof*(no_t_step-1));
for i_coef = 1:no_t_step-1
    
    coeff_assemb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
        coeff_assemb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
        coeff_MTX_A;
end

for i_coef = 1:no_t_step-2
    
   coeff_assemb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
        coeff_assemb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
        coeff_MTX_B; 
    
end