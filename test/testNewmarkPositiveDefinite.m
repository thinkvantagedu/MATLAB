clear; clc;

%%
phi = eye(2);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
%%
dt = 0.28;
maxt = 2.8;
u0 = [0; 0];
v0 = [0; 0];
%%
beta = 1/4; gamma = 1/2;
nd = length(m);
id = eye(nd);
iz = zeros(nd);
nr = size(phi, 2);
%%
t = 0:dt:(maxt);
nt = length(t);
%%
f = zeros(nd, nt);
for i = 1:nt        
    f(:, i) = f(1:2, i)+[0; 10];
end
%%
a0 = 1 / (beta * dt ^ 2);
a1 = gamma / beta / dt;
a2 = 1 / beta / dt;
a3 = 1 / 2 / beta - 1;
a4 = gamma / beta - 1;
a5 = dt / 2 * (gamma / beta - 2);

%%
% the dynamic operator
Hs = [m, c, k; iz, id, -a1 * id; id, iz, -a0 * id];

Hf = [iz, iz, iz; a5 * id, a4 * id, a1 * id; a3 * id, a2 * id, a0 * id];

Hst = [m, c, k; iz, id, iz; iz, iz, id];

Hz = zeros(3 * nd, 3 * nd);

Hasemb = cell(nt, nt);

for i = 1:nt
    
    if i == 1
        Hasemb(i, i) = {Hst};
    else
        Hasemb(i, i) = {Hs};
    end
        
end

for i = 1:nt - 1
    
    Hasemb(i + 1, i) = {Hf};
    
end

idx = cellfun(@(v) isempty(v), Hasemb, 'un', 0);

for i = 1:nt
    for j = 1:nt
        if idx{i, j} == 1
            Hasemb(i, j) = {Hz};
        end
    end
end

Hamtx = cell2mat(Hasemb);

%%
% the full force vector
fz = zeros(2 * 2, 1);
fvec = zeros(nt * nd * 3, 1);
for i = 1:nt
    
    fvec(i * nd * 3 - 5 : i * nd * 3) = fvec(i * nd * 3 - 5 : i * nd * 3) + ...
        [f(:, i); fz];
    
end

%%
% solution
u = Hamtx \ fvec;
u = reshape(u, [nd * 3, nt]);