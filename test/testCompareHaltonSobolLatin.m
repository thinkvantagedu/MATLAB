clear; clc; clf
% this script compares the 3sampling approaches: Halton, Sobol and Latin
% Hypercube by generating N points and plot these 3 in 1 figure. 

np = 10;
% Halton.
hp = haltonset(2);
xhp = hp(1:np, 1);
yhp = hp(1:np, 2);
scatter(xhp, yhp, 'filled');
hold on

% Sobol.
sp = sobolset(2);
xsp = sp(1:np, 1);
ysp = sp(1:np, 2);
scatter(xsp, ysp, 'filled');

% Latin hypercube.
lp = lhsdesign(np, 2);
scatter(lp(:, 1), lp(:, 2), 'filled');

legend('Halton', 'Sobol', 'Latin')

axis square