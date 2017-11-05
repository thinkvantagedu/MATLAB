clear; clc;
% number of degrees of freedom.
nD = 8;
% number of time steps
nT = 5;
% number of SVD results: left, singular, right.
nSVD = 3;
% number of solutions.
nS = 6;
% original space-time vector.
u1v = (1:40)';
u2v = (3:42)';
u3v = (5:44)';
u4v = (0:39)';
u5v = (2:41)';
u6v = (7:46)';
ufv = (4:43)';

uv = [ufv -u1v -u2v -u3v -u4v -u5v -u6v];

uvtra = uv' * uv;

uvnm = sqrt(sum(uvtra(:)));
% reshaped space-time responses.
u1 = reshape(u1v, [nD, nT]);
u2 = reshape(u2v, [nD, nT]);
u3 = reshape(u3v, [nD, nT]);
u4 = reshape(u4v, [nD, nT]);
u5 = reshape(u5v, [nD, nT]);
u6 = reshape(u6v, [nD, nT]);
uf = reshape(ufv, [nD, nT]);
%
locIndicator = 0;
u = cell(1, 2, 3);
if locIndicator == 1
    % test the location of each solution.
    u{1, 1, 1} = 'u1';
    u{1, 2, 1} = 'u2';
    u{1, 1, 2} = 'u3';
    u{1, 2, 2} = 'u4';
    u{1, 1, 3} = 'u5';
    u{1, 2, 3} = 'u6';
else
    u{1, 1, 1} = u1;
    u{1, 2, 1} = u2;
    u{1, 1, 2} = u3;
    u{1, 2, 2} = u4;
    u{1, 1, 3} = u5;
    u{1, 2, 3} = u6;
    %% Fro norm of e.
    e = uf - (u1 + u2 + u3 + u4 + u5 + u6);
    enm = norm(e, 'fro');
    
    %% automated solution of SVD vector summation.
    [x, sig, y] = cellfun(@(v) svd(v, 'econ'), u, 'UniformOutput', false);
    xsigy = cell(1, 2, 3, nT);
    
    [xf, sigf, yf] = svd(uf, 'econ');
    
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
    
%     extxsigy = cellfun(@(v, i) v{i}, x,  'UniformOutput', false);
    
%     xsigytest = cellfun(@(a, b, c) {a{1}});
    
    res = 0;
    
    for i = 1:2 * 3 * nT
        for j = 1: 2 * 3 * nT
            
            a1 = xsigy{i}{1};
            a2 = xsigy{j}{1};
            b1 = xsigy{i}{3};
            b2 = xsigy{j}{3};
            t = xsigy{i}{2} * xsigy{j}{2} * (b1' * b2) * (a2' * a1);
            res = res + t;
            
        end
    end
    
    res = sqrt(res);
    
    %% explicit sum of traces
    trasum = sqrt(trace(...
        - u1' * uf + u1' * u1 + u1' * u2 + u1' * u3 + u1' * u4 + u1' * u5 + u1' * u6 + ...
        - u2' * uf + u2' * u1 + u2' * u2 + u2' * u3 + u2' * u4 + u2' * u5 + u2' * u6 + ...
        - u3' * uf + u3' * u1 + u3' * u2 + u3' * u3 + u3' * u4 + u3' * u5 + u3' * u6 + ...
        - u4' * uf + u4' * u1 + u4' * u2 + u4' * u3 + u4' * u4 + u4' * u5 + u4' * u6 + ...
        - u5' * uf + u5' * u1 + u5' * u2 + u5' * u3 + u5' * u4 + u5' * u5 + u5' * u6 + ...
        - u6' * uf + u6' * u1 + u6' * u2 + u6' * u3 + u6' * u4 + u6' * u5 + u6' * u6 + ...
        uf' * uf - uf' * u1 - uf' * u2 - uf' * u3 - uf' * u4 - uf' * u5 - uf' * u6));
    
    trasum1 = sqrt(...
        trace(u1' * u1) + trace(u1' * u2) + trace(u1' * u3) + trace(u1' * u4) + ...
        trace(u2' * u1) + trace(u2' * u2) + trace(u2' * u3) + trace(u2' * u4) + ...
        trace(u3' * u1) + trace(u3' * u2) + trace(u3' * u3) + trace(u3' * u4) + ...
        trace(u4' * u1) + trace(u4' * u2) + trace(u4' * u3) + trace(u4' * u4));
end

