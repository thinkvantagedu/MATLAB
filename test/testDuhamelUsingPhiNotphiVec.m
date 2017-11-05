clear variables; clc;
Phi=eye(2);
K = [6 -2; -2 4];
M = [2 0; 0 1];
C = [0 0; 0 0];

dT = 0.28;
maxT = 4.2;
U0 = [0; 0];
V0 = [0; 0];
acce = 'average';
nt = maxT / dT + 1;
nd = length(K);
% the real Phi.
phif = [1 2; 4 3];
nr = length(phif);
alpha = (1:nd * nt);
alpha = reshape(alpha, [nd, nt]);
%% original: residual = M\Phi\alpha + K\Phi\alpha, solve response for residual 
% as a force.

res = M * phif * alpha + K * phif * alpha;

[ures, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res, acce, dT, maxT, U0, V0);

%% case 1: use MphiVec and KphiVec as impulse forces, multiply impulse responses 
% with alpha, then sum.

% M * phiVec1
fm1init = zeros(nd, nt);
fm1init(:, 1) = fm1init(:, 1) + M * phif(:, 1);
fm1step = zeros(nd, nt); 
fm1step(:, 2) = fm1step(:, 2) + M * phif(:, 1);

[um1init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm1init, acce, dT, maxT, U0, V0);
[um1step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm1step, acce, dT, maxT, U0, V0);

um1 = zeros(nd, nt);
x = 0:nt - 1;

for i = 1:nt
    if i == 1
        um1 = um1 + um1init * alpha(1, i);
    else
        ushift = [zeros(nd, i - 2) um1step(:, 1:nt - i + 2)];
        um1 = um1 + ushift * alpha(1, i);
    end
end

% M * phiVec2
fm2init = zeros(nd, nt);
fm2init(:, 1) = fm2init(:, 1) + M * phif(:, 2);
fm2step = zeros(nd, nt); 
fm2step(:, 2) = fm2step(:, 2) + M * phif(:, 2);

[um2init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm2init, acce, dT, maxT, U0, V0);
[um2step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm2step, acce, dT, maxT, U0, V0);

um2 = zeros(nd, nt);
for i = 1:nt
    if i == 1
        um2 = um2 + um2init * alpha(2, i);
        
    else
        ushift = [zeros(nd, i - 2) um2step(:, 1:nt - i + 2)];
        um2 = um2 + ushift * alpha(2, i);
        
    end
end

% K * phiVec1
fk1init = zeros(nd, nt);
fk1init(:, 1) = fk1init(:, 1) + K * phif(:, 1);
fk1step = zeros(nd, nt); 
fk1step(:, 2) = fk1step(:, 2) + K * phif(:, 1);

[uk1init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fk1init, acce, dT, maxT, U0, V0);
[uk1step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fk1step, acce, dT, maxT, U0, V0);

uk1 = zeros(nd, nt);
for i = 1:nt
    if i == 1
        uk1 = uk1 + uk1init * alpha(1, i);
    else
        ushift = [zeros(nd, i - 2) uk1step(:, 1:nt - i + 2)];
        uk1 = uk1 + ushift * alpha(1, i);
    end
end

% K * phiVec2
fk2init = zeros(nd, nt);
fk2init(:, 1) = fk2init(:, 1) + K * phif(:, 2);
fk2step = zeros(nd, nt); 
fk2step(:, 2) = fk2step(:, 2) + K * phif(:, 2);

[uk2init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fk2init, acce, dT, maxT, U0, V0);
[uk2step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fk2step, acce, dT, maxT, U0, V0);

uk2 = zeros(nd, nt);
for i = 1:nt
    if i == 1
        uk2 = uk2 + uk2init * alpha(2, i);
    else
        ushift = [zeros(nd, i - 2) uk2step(:, 1:nt - i + 2)];
        uk2 = uk2 + ushift * alpha(2, i);
    end
end

uo = um1 + um2 + uk1 + uk2;
