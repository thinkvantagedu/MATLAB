clear; clc;
%%
phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
%%

u0 = [0; 0];
v0 = [0; 0];
acce = 'average';

ngap = 2;
x = (1:0.1:9.9);
xcoarse = (1:0.1 * ngap : 9.9);
fFunc = sin(x);
fFunccoarse = sin(xcoarse);


f = zeros(2, length(x));
f(2, :) = f(2, :)+fFunc;
nd = length(m);
nt = length(f);
dt = 1;
maxt = dt * (nt - 1);

fdof = 2;
[u, v, a, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, acce, dt, maxt, u0, v0);



%% apply ngap impulses at one time. 


fvalue = sparse(nd, ngap);
fvalue(fdof, :) = fvalue(fdof, :) + ones(1, ngap);

finit = sparse(nd, nt);
finit(:, 1:ngap) = finit(:, 1:ngap) + fvalue;

fstep = sparse(nd, nt);
fstep(:, ngap + 1:2 * ngap) = fstep(:, ngap + 1:2 * ngap) + fvalue;
%% U_single again needs one extra time step for superposition.
[uinit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, finit, acce, dt, maxt, u0, v0);
[ustep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, fstep, acce, dt, maxt, u0, v0);

U = zeros(2, nt);

for i_f = 1:round(nt / 2)
    %% U_impulse contains one extra time step.
    if i_f == 1
        U = U + uinit * fFunccoarse(1);
    elseif i_f > 1
        uimp = ([zeros(2, (i_f - 2) * ngap), ustep(:, 1:(nt - i_f + 2))]);
        U = U + uimp * fFunccoarse(i_f);
        keyboard
    end
    
end
