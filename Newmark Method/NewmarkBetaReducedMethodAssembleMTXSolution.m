% function [U_r, V_r, A_r, U, V, A, t, no_t_step] = NewmarkBetaReducedMethodAssembleMTXSolution...
%     (phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0)
% solve Newmark in one giant step. Following book, not Pierre's method,
% initial matrix block is on right hand side. 

% In results, time step starts from 1, not 0, so displacement 1 is not
% necessarily zero. Gives ecaxt same results as notes. 

clear variables; clc;
%%
phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
%%
dt = 0.28;
maxt = 1.12;
u0 = [0; 0];
v0 = [0; 0];
acce = 'average';
%%
switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end
nd = length(m);
id = eye(nd);
nr = size(phi, 2);
%%
t = 0:dt:(maxt);
nt = length(t);
%%
f = zeros(nd, nt);
for i = 1:nt        
    f(:, i) = f(1:2, i)+[0; 10];
end
%%
a0 = m \ (f(:, 1) - c * v0 - k * u0);
qini = [a0; v0; u0];
qrcol = zeros(3 * nd * nt, 1);
qrcol(1:3 * nd, :) = qrcol(1:3 * nd, :) + qini;
qrrow = zeros(3 * nd, nt);
%%
a1 = gamma * dt;
a2 = beta * dt ^ 2;
a3 = (1 - gamma) * dt;
a4 = (1 / 2 - beta) * dt ^ 2;
a5 = (beta - 0.5) * dt ^ 2;
mtxA = [m c k; a1 * id, -id, 0 * id; a2 * id, 0 * id, - id];
mtxB = [0 * id 0 * id 0 * id; a3 * id id 0 * id; a4 * id dt * id id];
coefAsemb = sparse(3 * nd * (nt), 3 * nd * (nt));
%%
ft = sparse(3 * nd * (nt), 1);
fini = [f(:, 1); -a3 * a0 - v0; a5 * a0 - v0 - u0];
fadd = sparse(2 * nd, 1);
%%
for i = 1:nt
    
    coefAsemb((i - 1) * 3 * nd + 1 : i * 3 * nd, (i - 1) * 3 * nd + 1 : i * 3 * nd) = ...
        coefAsemb((i - 1) * 3 * nd + 1 : i * 3 * nd, (i - 1) * 3 * nd + 1:i * 3 * nd) + ...
        mtxA;
    ft((i - 1) * 3 * nd + 1 : i * 3 * nd, :) = ft((i - 1) * 3 * nd + 1 : i * 3 * nd, :) + ...
        [f(:, i); fadd];
    
end
   
for i = 1:nt-1
    
   coefAsemb((i * 3 * nd + 1) : (i + 1) * 3 * nd, (i - 1) * 3 * nd + 1 : i * 3 * nd) = ...
        coefAsemb((i * 3 * nd + 1) : (i + 1) * 3 * nd, (i - 1) * 3 * nd + 1:i * 3 * nd) + ...
        mtxB; 
    
end

ft(1:3 * nd, :) = zeros(3 * nd, 1);
ft(1:3 * nd, :) = ft(1:3 * nd, :) + fini;

qrcol = qrcol + coefAsemb \ ft;

%%
for i = 1:nt
    
    qrrow(:, i) = qrrow(:, i) + qrcol((i - 1) * nd * 3 + 1:i * nd * 3);
    
end
A_r = qrrow(1:nr, :);
V_r = qrrow(nr + 1:2 * nr, :);
U_r = qrrow(2 * nr + 1:3 * nr, :);
%%
Q_row = zeros(3 * length(phi), nt);
for i = 1:3
    
    Q_row((i - 1) * length(phi) + 1:i * length(phi), :) = Q_row((i - 1) * length(phi) + 1:i * length(phi), :) + ...
        phi * qrrow((i - 1) * nd + 1:i * nd, :);
    
end

A = Q_row(1:nd, :);
V = Q_row(nd + 1:2 * nd, :);
U = Q_row(2 * nd+1:3 * nd, :);
