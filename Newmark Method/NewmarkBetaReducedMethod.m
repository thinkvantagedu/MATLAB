function [U_r, V_r, A_r, U, V, A, t, time_step_NO] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0)
% hold on
% clear variables; clc;
% % for i = 1:16
% Phi=eye(2);
% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% 
% F_r=zeros(2, 16);
% for i_f0=1:length(F_r)
%     F_r(:, i_f0)=F_r(:, i_f0)+[0; 10];
% end
% dT=0.28;
% maxT=4.2;
% U0=[0; 0];
% V0=[0; 0];
% acce='average';

switch acce
    case 'average'
         beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
         beta = 1/6; gamma = 1/2;
end

%%
% Time step and initial conditions U0, V0.
t = 0:dT:(maxT);
time_step_NO = length(t);

U_r = zeros(length(K_r), length(t));
U_r(:, 1) = U_r(:, 1)+U0;
V_r = zeros(length(K_r), length(t));
V_r(:, 1) = V_r(:, 1)+V0;
A_r = zeros(length(K_r), length(t));
A_r(:, 1) = A_r(:, 1)+M_r\(F_r(:, 1)-C_r*V_r(:, 1)-K_r*U_r(:, 1));

a0 = 1/(beta*dT^2);
a1 = gamma/(beta*dT);
a2 = 1/(beta*dT);
a3 = 1/(2*beta)-1;
a4 = gamma/beta-1;
a5 = gamma*dT/(2*beta)-dT;
a6 = dT-gamma*dT;
a7 = gamma*dT;

Khat = K_r+a0*M_r+a1*C_r;

for i_nm = 1:length(t)-1
        
    dFhat = F_r(:, i_nm+1) + ...
        M_r*(a0*U_r(:, i_nm)+a2*V_r(:, i_nm)+a3*A_r(:, i_nm)) + ...
        C_r*(a1*U_r(:, i_nm)+a4*V_r(:, i_nm)+a5*A_r(:, i_nm));
    dU_r = Khat\dFhat;
    dA_r = a0*dU_r-a0*U_r(:, i_nm)-a2*V_r(:, i_nm)-a3*A_r(:, i_nm);
    dV_r = V_r(:, i_nm)+a6*A_r(:, i_nm)+a7*dA_r;
    U_r(:, i_nm+1) = dU_r;
    V_r(:, i_nm+1) = dV_r;
    A_r(:, i_nm+1) = dA_r;
    
end

A = Phi*A_r;
V = Phi*V_r;
U = Phi*U_r;

% x=[1:time_step_NO];
% plot(x, U_r(2, :));
% axis([1 16 -1 1.5]);
% xlabel('time')
% ylabel('displacement')
% end
