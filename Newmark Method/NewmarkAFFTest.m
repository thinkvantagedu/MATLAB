clear variables; clc;

Phi=eye(2);
K_r=[6 -2; -2 4];
M_r=[2 0; 0 1];
C_r=[0 0; 0 0];

x = (0:0.2:2*pi-0.2);
y = 5*x;
F_r=zeros(2, 31);
% y = zeros(1, 11)+10;
% for i_f0=1:length(F_r)
    F_r(2, :)=F_r(2, :)+y;
% F_r(:, 2) = F_r(:, 2)+[0; 10];
% end
dT=0.1;
maxT=3;
U0=[0; 0];
V0=[0; 0];
acce='average';
t = 0:dT:(maxT);
no_t_step = length(t);
[U_r, V_r, A_r, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0);

%% one extra time step is needed for superposition.
F = sparse(2, no_t_step+1);
F(:, 1) = F(:, 1)+[0; 1];
[U_sing, V, A, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F, acce, dT, maxT+dT, U0, V0);

U0 = zeros(2, no_t_step+1);
U = zeros(2, no_t_step);

for i_f = 1:no_t_step
    
    U_imp = ([zeros(2, i_f-1), U_sing(:, 1:(no_t_step-i_f+2))]);
    U0 = U0+U_imp*y(i_f);
    U(:, i_f) = U(:, i_f)+U0(:, i_f)+U0(:, i_f+1);
    keyboard
    
end
% fce_dof = 2;
% [U] = GSANMDuhamelsIntegral(y, fce_dof, Phi, M_r, C_r, K_r, acce, dT, maxT, U0, V0);