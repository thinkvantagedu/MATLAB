clear; clc;

nt = 6;
nd = 4;
% 
% a = (1:nd * nt);
% 
% a = reshape(a, [nd, nt]);
a = rand(nd, nt);
% origin

[al, asig, ar] = svd(a, 'econ');

ar = ar';

% shift right vector, keep left vector.

% shift right vector:

arshift = [zeros(nd, nt - 3) ar(:, 4:end)];

ashift = al * asig * arshift;

ashiftOri = [zeros(nd, nt - 3) a(:, 4:end)];

[ashiftl, ashiftsig, ashiftr] = svd(ashiftOri, 'econ');

% proving that al * asig * arshift = ashiftl * ashiftsig * ashiftr'.