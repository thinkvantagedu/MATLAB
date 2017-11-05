function [coeff_MTX_B] = NewmarkAssembleLocalB(acce, no_dof, dT)
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

coeff = eye(no_dof);

%%
a3 = (1-gamma)*dT;
a4 = (1/2-beta)*dT^2;

coeff_MTX_B = [0*coeff 0*coeff 0*coeff; a3*coeff coeff 0*coeff; a4*coeff dT*coeff coeff];
