% this script tests the proposed method with a micro model.

clear; clc;
%%
phione = eye(2);
sti = [6 -2; -2 4];
mas = [2 0; 0 1];
dam = [0 0; 0 0];
u0 = [0; 0];
v0 = [0; 0];
acce = 'average';

nt = 5;
nf = 3; % only m, c, k, no separate affined terms. 
ni = 2; % use 1, 5 as interpolation samples. 

fFunc = [0 10]';
fce = zeros(2, nt);
for i = 1:length(fce)
    fce(:, i) = fce(:, i) + fFunc;
end

nd = length(mas);

dt = 0.28;
maxt = dt * (nt - 1);

x = (1:5);

x1 = 1;
x5 = 5;
% input x
x3 = 3;

%% exact solutions.

[u1, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x1 * sti, fce, acce, dt, maxt, u0, v0);

[u3, v3, a3, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x3 * sti, fce, acce, dt, maxt, u0, v0);

[u5, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x5 * sti, fce, acce, dt, maxt, u0, v0);

%% solutions from reduced system.
snap = [u1 u5];
[l, sig ,r] = svd(snap, 'econ');

nr = 2;
phi = l(:, 1:nr);

mr = phi' * mas * phi;
cr = zeros(nr);
kr = phi' * sti * phi;
fr = phi' * fce;
u0r = zeros(nr, 1);
v0r = zeros(nr, 1);

[al3u, al3v, al3a, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, mr, cr, x3 * kr, fr, acce, dt, maxt, u0r, v0r);

u3r = phi * al3u;
v3r = phi * al3v;
a3r = phi * al3a;

%% reconstruct solutions from convoluted displacements and reduced variables.
impm = mas * phi;
impc = zeros(size(impm));
impk = sti * phi;
% store single imp vectors
impmck = {impm; impc; impk};
% from vectors generate impulses. Dim(imp) = (nf, 2, nr), only initial and
% successive impulses needs to be generated.
% we see these impulses are pm-independent.
% the order is always ni, nf, nt, nr, follow 
impStore = cell(nf, 2, nr);
for i = 1:nf
    for j = 1:2
        for k = 1:nr
            if j == 1
                imp = zeros(2, nt);
                imp(:, 1) = imp(:, 1) + impmck{i}(:, k);
                impStore{i, j, k} = imp;
            elseif j == 2
                imp = zeros(2, nt);
                imp(:, 2) = imp(:, 2) + impmck{i}(:, k);
                impStore{i, j, k} = imp;
            end
        end
    end
end

% from impulses generate responses.
respImpStore = cell(nf, 2, nr);
for i = 1:nf
    for j = 1:2
        for k = 1:nr
            [respImpSingle, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
                (phione, mas, dam, sti, impStore{i, j, k}, ...
                acce, dt, maxt, u0, v0);
            respImpStore{i, j, k} = respImpSingle;
        end
    end
end

% from imp responses generate shifted responses. 
respStore = cell(nf, nt, nr);
for i = 1:nf
    for j = 1:nt 
        for k = 1:nr
            if j == 1
                respStore{i, j, k} = respImpStore{i, 1, k};
            else
                rNz = respImpStore{i, 2, k}(:, 1:nt - j + 2);
                rz = zeros(2, j - 2);
                respInd = [rz rNz];
                respStore{i, j, k} = respInd;
            end
        end
    end
end

% test: reconstruct u3r from proposed method
u3rRecons = zeros(2, nt);
al3Store = {al3a; al3v; al3u};
for i = 1:nf
    for j = 1:nt
        for k = 1:nr
            u3rRecons = u3rRecons + respStore{i, j, k} * al3Store{i}(k, j);
        end
    end
end

%% interpolated solutions.
xc = [x1; x5];
yc = {u1; u5};

u3l = lagrange(xc, yc, x3, 'matrix');

%% obtain norm(u3, 'fro'), test norm with proposed interpolation method.
nu3 = norm(u3, 'fro');

% impulses are parameter-independent, and applied at the 
% [interpolation parameter-dependent]
% (very important to understand the procedure) sample points.

% here for each interpolation sample, there should be nf*nr*2 impulse
% responses (before shift). Thus total no of responses is ni*nf*nr*2.

respTotal = cell(ni, nf, 2, nr);




















