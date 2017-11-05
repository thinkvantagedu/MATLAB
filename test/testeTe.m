clear; clc;

e1 = 1:20;
e1 = reshape(e1, [5, 4]);

e2 = e1 + 3;
e2 = reshape(e2, [5, 4]);

%%
% e is  a sum of space-time response matrices. 
e = e1 + e2;

% Fro norm of e.
efro = norm(e, 'fro');

% explicitly, efro is sqrt(sum(diag(ete))).
ete = e' * e;
efrotest = sqrt(trace(ete));

%%
% transform e to evec.
evec1 = e1(:);

evec2 = e2(:);

evec = [evec1 evec2];

% Fro norm of evec. Can only be computed explicitly. 
evectevec = evec' * evec;
evecfro = sqrt(sum(evectevec(:)));

%% 
% obtain evectevec with SVD
nsvd = 4;
[e1x, e1sig, e1y] = svd(e1, 'econ');
[e2x, e2sig, e2y] = svd(e2, 'econ');

e1x = e1x * e1sig;
e2x = e2x * e2sig;

e1x = e1x(:, 1:nsvd);
e2x = e2x(:, 1:nsvd);
e1y = e1y(:, 1:nsvd);
e2y = e2y(:, 1:nsvd);

esvdt = e2y' * e1y * e1x' * e2x;

esvd = sqrt(sum(diag(esvdt)));