clear; clc; clf;
% this script tests convergence speed of Monte carlo area estimation using
% 3 sampling approaches: Halton, Sobol, Latin hypercube. 
np = 2 .^ (10:15);

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

% generate the 3 sequences of points.
hp = haltonset(2); % Halton
sp = sobolset(2); % Sobol
lp = lhsdesign(np(end), 2);

for ip = 1:length(np)
    hps = hp(1:np(ip), :);
    sps = sp(1:np(ip), :);
    lps = lp(1:np(ip), :); % Latin
end