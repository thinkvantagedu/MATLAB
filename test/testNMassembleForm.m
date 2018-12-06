clear; clc;
% demonstrate assembled form following thesis.
%% consitions and step-by-step solution.
phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = zeros(2);
% c = 0.1 * m + 0.1 * k;
dT = 28;
mT = 280;
u0 = [0; 0];
v0 = [0; 0];

nd = length(m);
id = eye(nd);
nr = size(phi, 2);
t = 0:dT:mT;
nT = length(t);
f = zeros(2, nT);
for i = 1:nT        
    f(:, i) = f(:, i) + [0; 10];
end
f(:, 1) = [0; 0];
[~, ~, ~, u, v, a, ~, ~] = NewmarkBetaReducedMethod...
    (phi, m, c, k, f, 'average', dT, mT, u0, v0);
beta = 1/4; gamma = 1/2;
a0 = 1 / (beta * dT ^ 2);
a1 = gamma / (beta * dT);
a2 = 1 / (beta * dT);
a3 = 1 / (2 * beta) - 1;
a4 = gamma / beta - 1;
a5 = dT / 2 * (gamma / beta - 2);

%% assembled form.
% Hs for initial step.
Hs_tilda = zeros(6);
mI = eye(2);
Hs_tilda(1:2, 1:2) = Hs_tilda(1:2, 1:2) + m;
Hs_tilda(1:2, 3:4) = Hs_tilda(1:2, 3:4) + c;
Hs_tilda(1:2, 5:6) = Hs_tilda(1:2, 5:6) + k;
Hs_tilda(3:4, 3:4) = Hs_tilda(3:4, 3:4) + mI;
Hs_tilda(5:6, 5:6) = Hs_tilda(5:6, 5:6) + mI;

% Hs for successive steps.
Hs = zeros(6);
Hs(1:2, 1:2) = Hs(1:2, 1:2) + m;
Hs(1:2, 3:4) = Hs(1:2, 3:4) + c;
Hs(1:2, 5:6) = Hs(1:2, 5:6) + k;
Hs(3:4, 3:4) = Hs(3:4, 3:4) + mI;
Hs(5:6, 1:2) = Hs(5:6, 1:2) + mI;
Hs(3:4, 5:6) = Hs(3:4, 5:6) + mI * (-a1);
Hs(5:6, 5:6) = Hs(5:6, 5:6) + mI * (-a0);

% Hf for all steps.
Hf = zeros(6);
Hf(3:4, 1:2) = Hf(3:4, 1:2) + mI * a5;
Hf(3:4, 3:4) = Hf(3:4, 3:4) + mI * a4;
Hf(3:4, 5:6) = Hf(3:4, 5:6) + mI * a1;
Hf(5:6, 1:2) = Hf(5:6, 1:2) + mI * a3;
Hf(5:6, 3:4) = Hf(5:6, 3:4) + mI * a2;
Hf(5:6, 5:6) = Hf(5:6, 5:6) + mI * a0;

fMtx = zeros(6, nT);
fMtx(1:2, :) = fMtx(1:2, :) + f;

fVec = fMtx(:);

% assemble A.
A = zeros(6 * (nT));
A = mat2cell(A, 6 * ones(1, nT), 6 * ones(1, nT));
% add diagonal blocks.
for it = 1:nT
    
    if it == 1
        A{it, it} = Hs_tilda;
    else
        A{it, it} = Hs;
    end
    
end

for jt = 1:nT - 1
    
    A{jt + 1, jt} = Hf;
    
end

A = cell2mat(A);

X = A \ fVec;
X = reshape(X, [6, nT]);