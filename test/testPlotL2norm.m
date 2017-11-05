clear; clc;

x = -1:0.01:1;
y = sqrt(1 - x .^ 2);

plot(x, y)

hold on

plot(x, -y)

axis square