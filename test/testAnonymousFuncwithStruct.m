clear; clc;

summation = @(x, y) x.x1 * y.y1 + x.x2 * y.y2 + x.x3 * y.y3;

x.a.x1 = 1; 

x.a.x2 = 2;

x.a.x3 = 3;

y.b.y1 = 4; 

y.b.y2 = 5;

y.b.y3 = 6;

z = summation(x.a, y.b);