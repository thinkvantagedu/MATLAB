clear; clc; clf;
% this script tests Latin Hypercube.
x = lhsdesign(10,2);
scatter(x(:,1), x(:,2), 'filled');
axis square