function [coeff_noK_A] = NewmarkAssembleLocalAnoK(acce, M_r, C_r, dT)
% size of assembled matrix equals to length(t)-1, because initial time step
% needs to be pre-calculated with initial condition.

% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% %%
% dT=0.28;
% maxT=2.8;
% U0=[0; 0];
% V0=[0; 0];
% acce='average';
switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end

no_dof = length(M_r);
coeff = eye(no_dof);

%%
a1 = gamma*dT;
a2 = beta*dT^2;

coeff_noK_A = [M_r C_r 0*coeff; a1*coeff -coeff 0*coeff; a2*coeff 0*coeff -coeff];
