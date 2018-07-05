clear; clc; clf;
% this script tests Sobol quasi-random point set.
% total number of random points.
np = 100;
hp = sobolset(2);
xp = hp(1:np, 1);
yp = hp(1:np, 2);
scatter(xp, yp, 'filled');
axis square
title(strcat({'Sobol sequence, '}, num2str(np), {' '}, {'points'}))