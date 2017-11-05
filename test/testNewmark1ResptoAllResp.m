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
phif = [0.8 -0.6; 0.6 0.8];
nr = length(phif);
alpha = rand(2, 16);
%% original: residual = M\Phi\alpha + K\Phi\alpha, solve response for residual
% as a force.

res = M * phif * alpha + K * phif * alpha;

[ures, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, res, acce, dT, maxT, U0, V0);

%% test: is Uijr proportional to profile of IMPijr?

fm1a = M * phif(:, 1);
fm2a = M * phif(:, 2);

fampfac = fm2a ./ fm1a;

fm1in = zeros(nd, nt);
fm1in(:, 1) = fm1in(:, 1) + fm1a;
[um1in, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm1in, acce, dT, maxT, U0, V0);

fm2in = zeros(nd, nt);
fm2in(:, 1) = fm2in(:, 1) + fm2a;
[um2in, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fm2in, acce, dT, maxT, U0, V0);

fm1inc = fm1in(:)';
fm2inc = fm2in(:)';

fdiag = zeros(nd * nt, 1);
fdiag(1:2) = fdiag(1:2) + fampfac;
ftr = diag(fdiag);

um1inc = um1in(:)';
um2inc = um2in(:)';

ut = um1inc * ftr;


% fma = fm1a + fm2a;
% fmin = zeros(nd, nt);
% fmin(:, 1) = fmin(:, 1) + fma;
% [umin, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%     (Phi, M, C, K, fmin, acce, dT, maxT, U0, V0);
% 
% 
% fmunit = zeros(nd, nt);
% fmunit(:, 1) = fmunit(:, 1) + [1; 1];
% [umunit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%     (Phi, M, C, K, fmunit, acce, dT, maxT, U0, V0);