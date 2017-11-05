clear variables; clc;
phi = [1 3; 2 4];
%%
K = [6 -2; -2 4];
M = [2 0; 0 1];
C = [0 0; 0 0];
%%
dt = 28;
maxT = 56;
U0 = [0; 0];
V0 = [0; 0];
acce = 'average';
%%
switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end
nd = length(M);
id = eye(nd);
iz = zeros(nd);
izb = zeros(3 * nd);
nr = size(phi, 2);
%%
t = 0:dt:(maxT);
nt = length(t);
a0 = 1 / beta / dt ^ 2;
a1 = gamma / beta / dt;
a2 = 1 / beta / dt;
a3 = 1 / 2 / beta - 1;
a4 = gamma / beta - 1;
a5 = dt / 2 * (gamma / beta - 2);

F = zeros(nd, nt);
for i_f0 = 1:nt
    F(:, i_f0) = F(1:2, i_f0) + [0; 10];
end
%% solve alpha;
Kr = phi' * K * phi;
Cr = phi' * C * phi;
Mr = phi' * M * phi;
Fr = phi' * F;
[~, ~, ~, alU, alV, alA, ~, ~] = NewmarkBetaReducedMethod...
    (1, Mr, Cr, Kr, Fr, acce, dt, maxT, 0, 0);
A = phi * alA;
V = phi * alV;
U = phi * alU;
al = [alA; alV; alU];
alcol = reshape(al, [nr * nt * 3, 1]);
%%
phiblk = cell(9);
for i = 1:9
    for j  = 1:9
        if i == j
            phiblk(i, j) = {phi};
        else
            phiblk(i, j) = {zeros(2, nr)};
        end
    end
end
phiblk = cell2mat(phiblk);


hst = [M C K; iz id iz; iz iz id];
hs = [M C K; iz id -a1 * id; id iz -a0 * id];
hf = [iz iz iz; a5 * id a4 * id a1 * id; a3 * id a2 * id a0 * id];

blk = [hst izb izb; hf hs izb; izb hf hs];

gcol = blk * phiblk * alcol;

g = reshape(gcol, [nd * 3, nt]);
gpick = g(1:2, :);

[~, ~, ~, Ut, Vt, At, ~, ~] = NewmarkBetaReducedMethod...
    (eye(2), M, C, K, gpick, acce, dt, maxT, U0, V0);