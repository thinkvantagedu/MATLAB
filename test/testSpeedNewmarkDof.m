% Perform Newmark once (the function, not OOP method), test speed with different 
% number of dofs. Change inputs accordingly, works with OOP and airfoil model. 

pm1 = 1000;
pm2 = 1000;
pm3 = 1000;
Phi = sparse(eye(canti.no.dof));
M_r = canti.mas.mtx;
C_r = canti.dam.mtx;
K_r = canti.sti.mtxCell{1} * pm1 + ...
    canti.sti.mtxCell{2} * pm2 + ...
    canti.sti.mtxCell{3} * pm3;

F_r = canti.fce.val;

acce = 'average';
dT = canti.time.step;
maxT = canti.time.max;

U0 = canti.dis.inpt;
V0 = canti.vel.inpt;

[U_r, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M_r, C_r, K_r, F_r, acce, dT, maxT, U0, V0);

f = @() NewmarkBetaReducedMethod;
timeit(f)