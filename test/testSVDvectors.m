clear variables; clc;

a = [1:12; 3:14; 5:16; 2:13]';
%%
[x, y, z] = svd(a, 0); % thin svd

no.nrb = 2;

recons = x(:, 1:no.nrb) * y(1:no.nrb, 1:no.nrb) * z(:, 1:no.nrb)';

%%
[x1, y1, z1] = SVDmod(a, 2);