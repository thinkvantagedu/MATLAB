function [coeff_K_A] = NewmarkAssembleLocalMTXonlyK(K_r)

no_dof = length(K_r);
coeff = eye(no_dof);

%%
coeff_K_A = [0*coeff 0*coeff K_r; 0*coeff 0*coeff 0*coeff; 0*coeff 0*coeff 0*coeff];
