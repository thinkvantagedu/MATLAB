clear; clc;
% this script tests adding damping in a SDOF dynamic model.
phi = eye(2);

dT = 0.28;
mT = 0.56;
nT = length(0:dT:mT);

k = [6 -2; -2 4];
m = [2 0; 0 1];
% c = 0.1 * m + 0.1 * k;
c = zeros(2);
f = zeros(2, nT);
% for iF = 1:length(f)
%     f(:, iF) = f(:, iF) + [0; 10];
% end
f(:, 1) = [0; 10];

u0 = [0; 0];
v0 = [0; 0];

[~, ~, ~, u, v, a, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dT, mT, u0, v0);

%%
% x = (0:dT:mT);
% plot(x, u(1, :));
% grid on

[~, Q, ~, ~]=NewmarkBetaReducedMethodMTXSolution...
    (phi, m, c, k, f, 'average', dT, mT, u0, v0);