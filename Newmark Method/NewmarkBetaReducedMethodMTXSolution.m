function [Q_r, Q, t, nT]=NewmarkBetaReducedMethodMTXSolution...
    (phi, M_r, C_r, K_r, F_r, acce, dT, mT, U0, V0)
% solve Newmark in time steps, each time step is solved by solving H1X1+H0X0=g1, 
% rather than solving linear equations. Output in size of 3*DOF by number
% of time step. Acce, Velo, Disp are together (3*DOF), thus only output is
% Q. 

no_dof = length(M_r);
id = eye(no_dof);
switch acce
    case 'average'
         beta = 1 / 4; gamma = 1 / 2; % al = alpha
    case 'linear'
         beta = 1 / 6; gamma = 1 / 2;
end
t = 0:dT:mT;
nT = length(t);

a0 = 1 / (beta * dT ^ 2);
a1 = gamma / (beta * dT);
a2 = 1 / (beta * dT);
a3 = 1 / (2 * beta) - 1;
a4 = gamma / beta - 1;
a5 = gamma * dT / (2 * beta) - dT;

Hs = [M_r, C_r, K_r; 0 * id, id, -a1 * id; id, 0 * id, -a0 * id];
Hf = [0 * id, 0 * id, 0 * id; a5 * id, a4 * id, a1 * id; ...
    a3 * id, a2 * id, a0 * id];

A0 = M_r \ (F_r(:, 1) - C_r * V0 - K_r * U0);

Q_r = zeros(3 * no_dof, nT);

Q_r(:, 1) = Q_r(:, 1)+[A0; V0; U0];

F = zeros(3 * no_dof, nT);

F(1:no_dof, :) = F(1:no_dof, :) + F_r;

for i_r = 1:nT-1
    
    Q_r(:, i_r+1) = Hs \ (F(:, i_r + 1) - Hf * Q_r(:, i_r));

end

Q = zeros(3 * length(phi), nT);

for i = 1:3
    
    Q((i-1) * length(phi) + 1:i * length(phi), :) = ...
        Q((i-1) * length(phi) + 1:i * length(phi), :) + ...
        phi * Q_r((i - 1) * no_dof + 1:i * no_dof, :);
    
end
