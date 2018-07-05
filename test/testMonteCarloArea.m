clear; clc; clf;
% this script tests Monte-Carlo to calculate area. 
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
%% Monte Carlo.
% total number of random points.
N = 1000;
% generate N random points.
x = unifrnd(0, 12, [1, N]);
y = unifrnd(0, 9, [1, N]);
% calculate frequency, i.e. how many points are inside the pattern.
freq = sum(y < x .^ 2 & x <= 3) + sum(y < 12 - x & x >= 3);
% area of the rectangle.
areaRec = 12 * 9;
ratio = freq / N;
area = areaRec * (freq / N);

hold on
scatter(x, y)
axis square



% Monte-Carlo can be pseudo-random in this case. If not pseudo-random, use
% low-discrepancy sequence such as Halton or Hammersley or Sobol sequence. 
