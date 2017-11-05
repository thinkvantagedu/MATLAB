function [U_r, V_r, A_r, U, V, A, t, time_step_NO]=NewmarkBetaReducedMethodwithINVMTX...
    (Phi, inv_mtx_hat, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0, a1, a2)
% clear variables; clc;
% 
% Phi=eye(2);
% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% 
% F_r=zeros(2, 11);
% for i_f0=1:length(F_r)
%     F_r(:, i_f0)=F_r(:, i_f0)+[0; 10];
% end
% dT=28;
% maxT=280;
% U0=[0; 0];
% V0=[0; 0];
% acce='average';
switch acce
    case 'average'
        beta=1/4; gamma=1/2; % al=alpha
    case 'linear'
        beta=1/6; gamma=1/2;
end
% a1 = gamma/(beta*dT);
% a2 = 1/(beta*dT^2);
% mtx_hat = K_r+a1*C_r+a2*M_r;
% inv_mtx_hat = inv(mtx_hat);
%%
% Time step and initial conditions U0, V0.
t=0:dT:(maxT);
time_step_NO=maxT/dT;

U_r=zeros(length(K_r), length(t));
U_r(:, 1)=U_r(:, 1)+U0;
V_r=zeros(length(K_r), length(t));
V_r(:, 1)=V_r(:, 1)+V0;
A_r=zeros(length(K_r), length(t));
A_r(:, 1)=A_r(:, 1)+M_r\(F_r(:, 1)-C_r*V_r(:, 1)-K_r*U_r(:, 1));
%%
% Coefficients
a3=1/(beta*dT);
a4=gamma/beta;
a5=1/(2*beta);
a6=dT*(gamma/(2*beta)-1);

%%
a=a3*M_r+a4*C_r;
b=a5*M_r+a6*C_r;

%%
for i_nm=1:length(t)-1
    
    dFhat=F_r(:, i_nm+1)-F_r(:, i_nm)+a*V_r(:, i_nm)+b*A_r(:, i_nm);
    dU_r=inv_mtx_hat*dFhat;
    dV_r=a1*dU_r-a4*V_r(:, i_nm)-a6*A_r(:, i_nm);
    dA_r=a2*dU_r-a3*V_r(:, i_nm)-a5*A_r(:, i_nm);
    U_r(:, i_nm+1)=U_r(:, i_nm)+dU_r;
    V_r(:, i_nm+1)=V_r(:, i_nm)+dV_r;
    A_r(:, i_nm+1)=A_r(:, i_nm)+dA_r;
    
end
A_r=A_r(:, 1:size(A_r, 2));
V_r=V_r(:, 1:size(V_r, 2));
U_r=U_r(:, 1:size(U_r, 2));
A=Phi*A_r;
V=Phi*V_r;
U=Phi*U_r;

