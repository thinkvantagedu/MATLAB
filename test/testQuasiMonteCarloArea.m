clear; clc; clf;
% this script tests quasi Monte-Carlo. 
%% plot pattern. 
xaxis = 0 : 0.25 : 12;
y1 = xaxis .^ 2;
y2 = 12 - xaxis;
plot(xaxis, y1, xaxis, y2);
xlabel('x');
ylabel('y');
legend('y1 = x^2','y2 = 12 - x');
axis([0 12 0 9]);
grid minor
%% Quasi Monte Carlo.
% total number of random points.
N = 1000;
x = halton(10000,2,5577);