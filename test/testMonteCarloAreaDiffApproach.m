clear; clc; clf;
% this script tests convergence speed of Monte carlo area estimation using
% 3 sampling approaches: Halton, Sobol, Latin hypercube. 
np = 2 .^ (10:0.1:20);

% plot the 1/4 circle.
xaxis = 0 : 0.01 : 1;
yaxis = sqrt(1 - xaxis .^ 2);
plot(xaxis, yaxis);
xlabel('x');
ylabel('y');
legend('x^2 + y^2 = 1');
axis([0 1 0 1]);
grid minor
axis square

% generate the 3 sequence of points.
hp = haltonset(2); % Halton
sp = sobolset(2); % Sobol
lp = lhsdesign(np, 2); % Latin
