clear; clc;

p1 = [2 3];                         % First Point
p2 = [9 8];                         % Second Point
dp = p2-p1;                         % Difference
figure(1)
quiver(p1(1),p1(2),dp(1),dp(2),0)
grid
axis([0  10    0  10])
text(p1(1),p1(2), sprintf('(%.0f,%.0f)',p1))
text(p2(1),p2(2), sprintf('(%.0f,%.0f)',p2))