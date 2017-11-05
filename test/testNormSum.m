clear variables; clc;

%% matrix case
% u1, u2 are m * n matrices.
u1 = [1 : 20]';
u2 = [-8 : 11]';
u1 = reshape(u1, [5, 4]);
u2 = reshape(u2, [5, 4]);

% u1 = rand(6, 5);
% u2 = rand(6, 5);

ndof = size(u1, 1);
ntime = size(u1, 2);

% Frobenius norm of e.
e = u1 + u2;
fnme = norm(e, 'fro');

% square root of eTe trace, equals to Frobenius norm of e.
tre = trace(e' * e);
sqtre = sqrt(tre);

% explicit form of tr(eTe).
sep = u1' * u1 + u2' * u1 + u1' * u2 + u2' * u2;
sep = trace(sep);

% possible implementation: horizontal alignment of responses.
em = [u1 u2];
% emTem is a 2 by 2 blocks of ntime by ntime matrices.
emprod = em' * em;
% split into cell blocks.
emblk = mat2cell(emprod, [ntime, ntime], [ntime, ntime]);
% take trace of each block and sum, results in same result of eTe trace.
emtre = cellfun(@trace, emblk);
emtre = sum(emtre(:));

% SVD on u1 and u2
ecell = {u1; u2};
[ex, esig, ey] = cellfun(@(m) svd(m), ecell, 'UniformOutput', false);

sqtretest = 0;
sqtretest1 = 0;
for i = 1:ntime
    
    x1 = ex{1}(:, i);
    sig1 = esig{1}(i, i);
    y1 = ey{1}(:, i);
    
    x2 = ex{2}(:, i);
    sig2 = esig{2}(i, i);
    y2 = ey{2}(:, i);
    
    test = sig1 ^ 2 * trace(x1' * x1) * trace(y1 * y1') + ...
        2 * sig1 * sig2 * trace(x1' * x2) * trace(y1 * y2') + ...
        sig2 ^ 2 * trace(x2' * x2) * trace(y2 * y2');
    
    sqtretest = sqtretest + test;
    
    test1 = sig1 ^ 2 + 2 * sig1 * sig2 * x1' * x2 * y1' * y2 + sig2 ^ 2;
    
    sqtretest1 = sqtretest1 + test1;

end

sqtretest = sqrt(sqtretest);
sqtretest1 = sqrt(sqtretest1);

sqdif = abs(sqtretest - sqtre) / sqtre;

%%

