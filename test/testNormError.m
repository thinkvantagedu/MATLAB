clear; clc;
% number of degrees of freedom.
nD = 8;
% number of time steps
nT = 5;
% number of SVD results: left, singular, right.
nSVD = 3;
% number of solutions.
nS = 7;


u1v = (1:40)';
u2v = (3:42)';
u3v = (5:44)';
u4v = (0:39)';
u5v = (2:41)';
u6v = (7:46)';
ufv = (4:43)';

u1 = reshape(u1v, [nD, nT]);
u2 = reshape(u2v, [nD, nT]);
u3 = reshape(u3v, [nD, nT]);
u4 = reshape(u4v, [nD, nT]);
u5 = reshape(u5v, [nD, nT]);
u6 = reshape(u6v, [nD, nT]);
uf = reshape(ufv, [nD, nT]);
uv = [ufv -u1v -u2v -u3v -u4v -u5v -u6v];

uvtuv = uv' * uv;

u = cell(1, 2, 3);
u{1, 1, 1} = -u1;
u{1, 2, 1} = -u2;
u{1, 1, 2} = -u3;
u{1, 2, 2} = -u4;
u{1, 1, 3} = -u5;
u{1, 2, 3} = -u6;

[x, sig, y] = cellfun(@(v) svd(v, 'econ'), u, 'UniformOutput', false);
[xf, sigf, yf] = svd(uf, 'econ');

xsigyf = cell(1, 5);
for i = 1:nT
    
    a = xf(:, i);
    b = sigf(i, i);
    c = yf(:, i);
    xsigyf{i} = {a; b; c};
    
end

xsigy = cell(1, 2, 3, nT);
for i = 1:2
    for j = 1:3
        for k = 1:nT
            a = x{1, i, j}(:, k);
            b = sig{1, i, j}(k, k);
            c = y{1, i, j}(:, k);
            xsigy{1, i, j, k} = {a; b; c};
        end
    end
end

res = zeros(nS);
xsigy = reshape(xsigy, [2 * 3, nT]);
xsigy = [xsigyf; xsigy];

for i = 1:1*2*3 + 1
    for j = 1:1*2*3 + 1
        resPass = 0;
        for k = 1:nT
            
            xi = xsigy{i, k}{1};
            xj = xsigy{j, k}{1};
            sigi = xsigy{i, k}{2};
            sigj = xsigy{j, k}{2};
            yi = xsigy{i, k}{3};
            yj = xsigy{j, k}{3};
            resPass = resPass + sigi * sigj * yj' * yi * xi' * xj;
            
        end
        res(i, j) = res(i, j) + resPass;
    end
end