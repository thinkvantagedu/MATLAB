clear; clc;

%% parameters.
phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
u0 = [0; 0];
v0 = [0; 0];
acce = 'average';

x = (0:0.1:0.9);
fFunc = sin(x);
nd = length(m);
nt = length(x);

fdof = 2;
f = zeros(2, length(x));
f(2, :) = f(2, :)+fFunc;

dt = 1;
maxt = dt * (nt - 1);

%% original Newmark.
[u, v, a, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, acce, dt, maxt, u0, v0);

%% Duhamel's integral.
fvalues = zeros(nd, 1);
fvalues(fdof, :) = fvalues(fdof, :) + 1;

% CASE 1: small time step length.

finits = zeros(nd, nt);
finits(:, 1) = finits(:, 1) + fvalues;

fsteps = zeros(nd, nt);
fsteps(:, 2) = fsteps(:, 2) + fvalues;

[uinits, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, finits, acce, dt, maxt, u0, v0);
[usteps, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, fsteps, acce, dt, maxt, u0, v0);

us = zeros(nd, nt);

for i_f = 1:nt
    if i_f == 1
        us = us + uinits * fFunc(1);
    elseif i_f > 1
        uimps = ([zeros(2, i_f - 2), usteps(:, 1:(nt - i_f + 2))]);
        us = us + uimps * fFunc(i_f);
    end
end

us1 = [us(:, 2) us(:, 4) us(:, 6) us(:, 8) us(:, 10)];
us2 = [us(:, 1) us(:, 3) us(:, 5) us(:, 7) us(:, 9)];

% CASE 2: larger time step length.
ngap = 2;
xl = (0 : 0.1 * ngap : 0.9);
fFuncl = sin(xl);

fvaluel = zeros(nd, 1);
fvaluel(fdof, :) = fvaluel(fdof, :) + 1.08;

finitl = zeros(nd, nt / ngap);
finitl(:, 1) = finitl(:, 1) + fvaluel;

fstepl = zeros(nd, nt / ngap);
fstepl(:, 2) = fstepl(:, 2) + fvaluel;

dtl = dt * ngap;

[uinitl, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, finitl, acce, dtl, maxt, u0, v0);
[ustepl, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, fstepl, acce, dtl, maxt, u0, v0);

ul = zeros(nd, nt / ngap);

for i_f = 1:nt / ngap
    if i_f == 1
        ul = ul + uinitl * fFuncl(1);
    elseif i_f > 1
        uimpl = ([zeros(2, i_f - 2), ustepl(:, 1:(nt / ngap - i_f + 2))]);
        ul = ul + uimpl * fFuncl(i_f);
    end
end













