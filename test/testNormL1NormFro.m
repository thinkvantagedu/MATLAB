clear; clc;
% test norm 1 and Frobenius norm, what's the equivalent transformation?

u1 = (1:5)';
u2 = [-1 -2 -6 3 4]';

e = u1 - u2;
enm1 = norm(e, 1);

emtx = [u1 -u2];

%%
enm2 = norm(e, 'fro');

emtxt = emtx' * emtx;

enmts = sqrt(sum(emtxt(:)));

%% case 1: 1-norm.

a = sum(sqrt(sum(emtx .^ 2, 2) + 2 * prod(emtx, 2)));


%%
u3 = [-3 4 2 9 -7]';

e1 = u1 - u2 - u3;
enm11 = norm(e1, 1);

emtx1 = [u1 -u2 -u3];

a1 = sum(sqrt(sum(emtx1 .^ 2, 2) + 2 * prod(emtx1, 2)));

a11 = sum(sqrt(u1 .* u1 - u1 .* u2 - u1 .* u3 - u2 .* u1 + u2 .* u2 + u2 .* u3 - u3 .* u1 + u3 .* u2 + u3 .* u3));