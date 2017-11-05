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

%% case 2: calculate M\Phi + K\Phi, use them as a force, then try to multiply 
% with \alpha.
respass2 = M * phif + K * phif;

res2init = zeros(nd, nt);
res2init(:, 1:nr) = res2init(:, 1:nr) + respass2;

% resf2 = zeros(nd, nt);
% resf2(:, 1:nr) = resf2(:, 1:nr) + res2;
[u2init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res2init, acce, dT, maxT, U0, V0);

res2step = zeros(nd, nt);
res2step(:, 2:nr+1) = res2step(:, 2:nr+1) + respass2;

[u2step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res2step, acce, dT, maxT, U0, V0);

res2step1 = zeros(nd, nt);
res2step1(:, 3:nr+2) = res2step1(:, 3:nr+2) + respass2;

[u2step1, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res2step1, acce, dT, maxT, U0, V0);

%% case 3:
res31 = (M + K) * phif(:, 1);
res31init = zeros(nd, nt);
res31init(:, 1) = res31init(:, 1) + res31;
[u31init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res31init, acce, dT, maxT, U0, V0);
res31step = zeros(nd, nt);
res31step(:, 2) = res31step(:, 2) + res31;
[u31step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res31step, acce, dT, maxT, U0, V0);
u31 = zeros(nd, nt);
for i = 1:nt
    if i == 1
        u31 = u31 + u31init * alpha(1, i) * 2;
    else
        ushift = [zeros(nd, i - 2) u31step(:, 1:nt - i + 2)];
        u31 = u31 + ushift * alpha(1, i) * 2;
    end
end

res32 = (M + K) * phif(:, 2);
res32init = zeros(nd, nt);
res32init(:, 1) = res32init(:, 1) + res32;
[u32init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res32init, acce, dT, maxT, U0, V0);
res32step = zeros(nd, nt);
res32step(:, 2) = res32step(:, 2) + res32;
[u32step, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res32step, acce, dT, maxT, U0, V0);
u32 = zeros(nd, nt);
for i = 1:nt
    if i == 1
        u32 = u32 + u32init * alpha(2, i) * 2;
    else
        ushift = [zeros(nd, i - 2) u31step(:, 1:nt - i + 2)];
        u32 =u32 + ushift * alpha(2, i) * 2;
    end
end

u3 = u31 + u32;