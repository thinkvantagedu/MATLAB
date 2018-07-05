clear; clc; clf;
% this script tests Halton sequence.
% total number of random points.
np = 100;
hp = haltonset(2);
xp = hp(1:np, 1);
yp = hp(1:np, 2);
scatter(xp, yp, 'filled');
axis square
title(strcat({'Halton sequence, '}, num2str(np), {' '}, {'points'}))