function [Q_r, Q, t, no_t_step]=NewmarkBetaReducedMethodMTXSolution...
    (phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0)
% solve Newmark in time steps, each time step is solved by solving H1X1+H0X0=g1, 
% rather than solving linear equations. Output in size of 3*DOF by number
% of time step. Acce, Velo, Disp are together (3*DOF), thus only output is
% Q. 

% clear variables; clc;
% 
% phi=eye(2);
% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% 
% no_dof = length(M_r);
% coeff = eye(no_dof);
% 
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
t = 0:dT:(maxT);
no_t_step = length(t);

% F_r=zeros(no_dof, no_t_step);
% 
% for i_f0=1:no_t_step
%     F_r(1:2, i_f0)=F_r(1:2, i_f0)+[0; 10];
% end

a0 = 1/(beta*dT^2);
a1 = gamma/(beta*dT);
a2 = 1/(beta*dT);
a3 = 1/(2*beta)-1;
a4 = gamma/beta-1;
a5 = gamma*dT/(2*beta)-dT;

coeff_MTX_A = [M_r C_r K_r; 0*coeff coeff -a1*coeff; coeff 0*coeff -a0*coeff];
coeff_MTX_B = [0*coeff 0*coeff 0*coeff; a5*coeff a4*coeff a1*coeff; a3*coeff a2*coeff a0*coeff];


A0 = M_r\(F_r(:, 1)-C_r*V0-K_r*U0);

Q_r = zeros(3*no_dof, no_t_step);

Q_r(:, 1) = Q_r(:, 1)+[A0; V0; U0];

F = sparse(3*no_dof, no_t_step);

F(1:no_dof, :) = F(1:no_dof, :)+F_r;

for i_r = 1:no_t_step-1
    
    Q_r(:, i_r+1) = coeff_MTX_A\(F(:, i_r+1)-coeff_MTX_B*Q_r(:, i_r));
%     keyboard
end

Q = zeros(3*length(phi), no_t_step);

for i = 1:3
    
    Q((i-1)*length(phi)+1:i*length(phi), :) = Q((i-1)*length(phi)+1:i*length(phi), :)+...
        phi*Q_r((i-1)*no_dof+1:i*no_dof, :);
    
end
