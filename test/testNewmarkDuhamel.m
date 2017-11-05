clear; clc;
%%
Phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
%%

u0 = [0; 0];
v0 = [0; 0];
acce = 'average';

x = (1:0.1:10);

fFunc = sin(x);
f = zeros(2, length(x));
f(2, :) = f(2, :)+fFunc;
nd = length(m);
nt = length(f);
dt = 0.28;
maxt = dt * (nt - 1);

fdof = 2;
[u, v, a, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, m, c, k, f, acce, dt, maxt, u0, v0);



%% one extra time step is needed for superposition. Needs to know which dof in order to apply impulse.
finit = sparse(nd, nt);
fce = sparse(nd, 1);
fce(fdof) = fce(fdof) + 1;
finit(:, 1) = finit(:, 1) + fce;
fstep = sparse(nd, nt);
fstep(:, 2) = fstep(:, 2) + fce;
%% U_single again needs one extra time step for superposition.
[uinit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, m, c, k, finit, acce, dt, maxt, u0, v0);
[ustep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, m, c, k, fstep, acce, dt, maxt, u0, v0);

U = zeros(2, nt);

for i_f = 1:nt
    %% U_impulse contains one extra time step.
    if i_f == 1
        U = U + uinit * fFunc(1);
    elseif i_f > 1
        uimp = ([zeros(2, i_f - 2), ustep(:, 1:(nt - i_f + 2))]);
        U = U + uimp * fFunc(i_f);
    end
    
end
