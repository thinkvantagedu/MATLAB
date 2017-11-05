clear variables; clc;

% generate n*n symmetric random matrix.
n = 3;
[M] = randIntSymMTX(n);
% M = round(10*rand(n));

%%
a = (1:1:n)';

b = (n-1:-1:0);

subsidx = bsxfun(@plus,a,b);

subs = reshape(subsidx,[],1);

diagsum = @(subs, x) accumarray(subs, x);

res = diagsum(subs, M(:));

%%

uptriidx = find(triu(ones(n)));

subsuptri = subs(uptriidx);

muptri = M(uptriidx);


resuptri = diagsum(subsuptri, muptri);

