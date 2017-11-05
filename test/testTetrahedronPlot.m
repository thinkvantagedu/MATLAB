clear; clc;
d = [-1 1];
[x,y,z] = meshgrid(d,d,d); % a cube
x = [x(:);0];
y = [y(:);0];
z = [z(:);0];
DT = delaunayTriangulation(x,y,z);
tetramesh(DT);

coordinate = ...
[121.9864   -4.9838  223.7500
121.9864   -4.9838   13.7500
121.9864    4.9838   13.7500
121.9864    4.9838  223.7500
160.0000         0  223.7500
160.0000         0   13.7500];

connectivity = [6     5     4     1];

tetramesh(connectivity, coordinate, 2);