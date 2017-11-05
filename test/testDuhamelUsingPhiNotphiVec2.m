clear variables; clc;
Phi=eye(2);
K = [6 -2; -2 4];
M = [2 0; 0 1];
C = [0 0; 0 0];

dT = 0.28;
maxT = 1.4;
U0 = [0; 0];
V0 = [0; 0];
acce = 'average';
nt = round(maxT / dT) + 1;
nd = length(K);
% the real Phi.
phif = [1 2; 4 3];
nr = length(phif);
alpha = [1:6; 1:6];
%% case 1: residual = M\Phi\alpha + K\Phi\alpha, solve response for residual 
% as a force.

res1 = M * phif * alpha + K * phif * alpha;
[u1, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res1, acce, dT, maxT, U0, V0);

resm = M * phif * alpha;
resk = K * phif * alpha;
[uresm, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, resm, acce, dT, maxT, U0, V0);
[uresk, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, resk, acce, dT, maxT, U0, V0);
ures = uresm + uresk;
%% case 2;

phisum = phif(:, 1) + phif(:, 2);

fma = M * phisum;
fminit = zeros(nd, nt);
fminit(:, 1) = fminit(:, 1) + fma;
fmstep = zeros(nd, nt);
fmstep(:, 1) = fmstep(:, 1) + fma;

[uminit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fminit, acce, dT, maxT, U0, V0);
[umstep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fmstep, acce, dT, maxT, U0, V0);

alphasum = alpha(1, :) + alpha(2, :);
um = zeros(nd, nt);
for i = 1:nt
    if i == 1
        um = um + uminit * alphasum(i);
    else
        ushift = [zeros(nd, i - 2) umstep(:, 1:nt - i + 2)];
        um = um + ushift * alphasum(i);
    end
end

fka = K * phisum;
fkinit = zeros(nd, nt);
fkinit(:, 1) = fkinit(:, 1) + fka;
fkstep = zeros(nd, nt);
fkstep(:, 1) = fkstep(:, 1) + fka;

[ukinit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fkinit, acce, dT, maxT, U0, V0);
[ukstep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fkstep, acce, dT, maxT, U0, V0);

alphasum = alpha(1, :) + alpha(2, :);
uk = zeros(nd, nt);
for i = 1:nt
    if i == 1
        uk = uk + ukinit * alphasum(i);
    else
        ushift = [zeros(nd, i - 2) ukstep(:, 1:nt - i + 2)];
        uk = uk + ushift * alphasum(i);
    end
end

u2 = um + uk;