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

nt = 4;
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
xc = [x1; x5];

%% exact solutions.

[u1, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x1 * sti, fce, acce, dt, maxt, u0, v0);

[u3, v3, a3, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x3 * sti, fce, acce, dt, maxt, u0, v0);

[u5, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phione, mas, dam, x5 * sti, fce, acce, dt, maxt, u0, v0);

%% solutions from reduced system.
snap = [u1 u5];
[phil, sig ,phir] = svd(snap, 'econ');

nr = 2;
phi = phil(:, 1:nr);

mr = phi' * mas * phi;
cr = zeros(nr);
kr = phi' * sti * phi;
fr = phi' * fce;
u0r = zeros(nr, 1);
v0r = zeros(nr, 1);

[al3d, al3v, al3a, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phi, mr, cr, x3 * kr, fr, acce, dt, maxt, u0r, v0r);

u3r = phi * al3d;
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
                respStore{i, j, k} = [rz rNz];
            end
        end
    end
end

% test: reconstruct u3r from proposed method
u3rRecons = zeros(2, nt);
al3Store = {al3a; al3v; al3d};
for i = 1:nf
    for j = 1:nt
        for k = 1:nr
            u3rRecons = u3rRecons + respStore{i, j, k} * al3Store{i}(k, j);
        end
    end
end


%% obtain norm(u3, 'fro'), test norm with proposed interpolation method.
nmu3 = norm(u3, 'fro');

% impulses are parameter-independent, and applied at the 
% [interpolation parameter-dependent]
% (very important to understand the procedure) sample points.

% here for each interpolation sample, there should be nf*nr*2 impulse
% responses (before shift). Thus total no of responses is ni*nf*nr*2.

% compute the initial and successive displacements for itpl, phy, rb.
respDiff = cell(ni, nf, 2, nr);
for i = 1:ni
    pmPro = xc(i);
    stiPro = pmPro * sti;
    for j = 1:nf
        for k = 1:2
            for l = 1:nr
                [respPro, ~, ~, ~, ~, ~, ~, ~] = ...
                    NewmarkBetaReducedMethod...
                    (phione, mas, dam, stiPro, impStore{j, k, l}, ...
                    acce, dt, maxt, u0, v0);
                respDiff{i, j, k, l} = respPro;
            end
        end
    end
end
% shift the computed displacements to obtain time-dependent displacements.
respProStore = cell(ni, nf, nt, nr);
for i = 1:ni
    for j = 1:nf
        for k = 1:nt
            for l = 1:nr
                if k == 1
                    respProStore{i, j, k, l} = respDiff{i, j, k, l}(:);
                else
                    rNz = respDiff{i, j, 2, l}(:, 1:nt - k + 2);
                    rz = zeros(2, k - 2);
                    rtmp = [rz rNz];
                    respProStore{i, j, k, l} = rtmp(:);
                end
            end
        end
    end
end
% for each itpl sample, and compute eTe. 
errhhat = cell(ni, 2);
respResStore = cell(ni, 1);
for i = 1:ni
    errhhat{i, 1} = i;
    % extract e for each itpl sample.
    respPmPass = respProStore(i, :, :, :);
    % the cat operation gives: mr1t1, cr1t1, kr1t1, mr1t2, cr1t2, kr1t2,
    % ... mr2t1, cr2t1, kr2t1, mr2t2, cr2t2, kr2t2, ...
    respCol = cat(2, respPmPass{:});
    respResStore{i} = respCol;
    errhhat{i, 2} = respCol' * respCol;
end

% interpolate eTe for u3.
ycPro = errhhat(:, 2);
eTe3 = lagrange(xc, ycPro, x3, 'matrix');

% obtain the pm and rv vector.
pmPass = x3;
pmSlct = repmat([1; 1; pmPass], nt * nr, 1);

rvAccRow = al3a';
rvAccRow = rvAccRow(:);
rvAccRow = rvAccRow';
rvVelRow = al3v';
rvVelRow = rvVelRow(:);
rvVelRow = rvVelRow';
rvDisRow = al3d';
rvDisRow = rvDisRow(:);
rvDisRow = rvDisRow';

rvAllRow = [rvAccRow; rvVelRow; rvDisRow];
rvAllCol = rvAllRow(:);

% multiply the pm, rv vectors with eTe.
ePreSqrt = (rvAllCol .* pmSlct)' * eTe3 * (rvAllCol .* pmSlct);
nmeTe3 = sqrt(abs(ePreSqrt));

%% interpolate pre-computed displacements. 2 operations with same results!!!     %|
% respnm == respnm1;                                                             %|
respItpl = lagrange(xc, respResStore, x3, 'matrix');                             %|
                                                                                 %|
% multiply related rv and pm.                                                    %|
respnmsq = (rvAllCol .* pmSlct)' * (respItpl)' * respItpl * (rvAllCol .* pmSlct);%|
respnm1 = sqrt(respnmsq);                                                        %|
                                                                                 %|same operation
respSum = zeros(nd * nt, 1);                                                     %|
for i = 1:size(respItpl, 2)                                                      %|
    respSum = respSum + respItpl(:, i) * rvAllCol(i) * pmSlct(i);                %|
end                                                                              %|
                                                                                 %|
respnm = norm(respSum, 'fro');                                                   %|

%% test what should be correct.
lagCoef = [0.5; 0.5];
cTc = lagCoef * lagCoef';
ectec = cell(2, 2);
for i = 1:2
    for j = 1:2
        if j < i
            ectec{i, j} = ectec{j, i}';
        else
            ectec{i, j} = respResStore{i}' * respResStore{j};
        end
    end
end

eteotpt = zeros(nt * nr * nf, nt * nr * nf);
for i = 1:4
    eteotpt = eteotpt + ectec{i} * cTc(i);
end
ete = sqrt((rvAllCol .* pmSlct)' * eteotpt * (rvAllCol .* pmSlct));























