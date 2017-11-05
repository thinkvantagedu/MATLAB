function [coef_asmb] = NewmarkBetaReducedMethodAssembleSysMTX(M, C, K, acce, dT, maxT)

%% assemble the giant system matrix to solve dynamic problem in ONE GO. 

switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end
%%
a1 = gamma*dT;
a2 = beta*dT^2;
a3 = (1-gamma)*dT;
a4 = (1/2-beta)*dT^2;
a5 = (beta-0.5)*dT^2;
%%
no_dof = length(M);
coef_idn = eye(no_dof);
no_t_step = length(0:dT:maxT);
%%

coef_MTX_ini = [M C K; 0*coef_idn coef_idn 0*coef_idn; 0*coef_idn 0*coef_idn coef_idn];
coef_MTX_A = [M C K; a1*coef_idn -coef_idn 0*coef_idn; a2*coef_idn 0*coef_idn -coef_idn];
coef_MTX_B = [0*coef_idn 0*coef_idn 0*coef_idn; a3*coef_idn coef_idn 0*coef_idn; a4*coef_idn dT*coef_idn coef_idn];

coef_asmb = sparse(3*no_dof*(no_t_step), 3*no_dof*(no_t_step));

%%
for i_coef = 1:no_t_step
    if i_coef == 1
        coef_asmb(1:3*no_dof, 1:3*no_dof) = coef_asmb(1:3*no_dof, 1:3*no_dof)+coef_MTX_ini;
    else
        coef_asmb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
            coef_asmb((i_coef-1)*3*no_dof+1:i_coef*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
            coef_MTX_A;
    end
end

for i_coef = 1:no_t_step-1
    
   coef_asmb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof) = ...
        coef_asmb((i_coef*3*no_dof+1):(i_coef+1)*3*no_dof, (i_coef-1)*3*no_dof+1:i_coef*3*no_dof)+...
        coef_MTX_B; 
    
end