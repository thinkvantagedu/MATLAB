clear; clc;
nd = 4;
nt = 5;
nsvd = 2;

e1vec = (1:20)';
e2vec = e1vec + 5;

e1 = reshape(e1vec, [nd, nt]);
e2 = reshape(e2vec, [nd, nt]);

% e vector products.
evectevec = e1vec' * e2vec;

% e matrices products.
ete = trace(e1' * e2);

