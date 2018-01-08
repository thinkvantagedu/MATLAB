clear; clc; close;
%% matrix (no rotation)
% this script tests the projection of 
% case 1: a vector on a matrix, 
% case 2: a matrix on a matrix.

% case 1, m is matrix which should turn anything 45 degrees. 
hold on
m = [1 -1; 1 1];

% generate cartesian system.
quiver(-2, 0, 4.46, 0, 'Color', 'k')
quiver(0, -2, 0, 4.46, 'Color', 'k')

% generate new coord system from m.
quiver(-2, -2, 4.46, 4.46, 'Color', 'c');
quiver(2, -2, -4.46, 4.46, 'Color', 'c');

% blue is original, red is turned. 
v1 = [1 0];
r1 = v1 * m;

quiver(0, 0, v1(1), v1(2), 'Color', 'b');
quiver(0, 0, r1(1), r1(2), 'Color', 'r');

v2 = [0.25 1];
r2 = v2 * m;

quiver(0, 0, v2(1), v2(2), 'Color', 'b', 'LineWidth', 2);
quiver(0, 0, r2(1), r2(2), 'Color', 'r', 'LineWidth', 2);

title('Red vectors are turned 45 degrees from blue vectors by multiplying matrix m, black is Cardesian system, cyan is m system.')

axis([-2 2 -2 2])
axis square
grid on

% case 2, matrix contains v1 and v2 multiplies m, should gives vectors turned by
% 45 degrees.
% mv = [v1; v2];
% rm = mv * m;


%% rotation matrix
ro = [0 -1; 1 0]; % clockwise.
ro1 = v1 * ro;
ro2 = v2 * ro;

quiver(0, 0, ro1(1), ro1(2), 'Color', 'g');
quiver(0, 0, ro2(1), ro2(2), 'Color', 'g', 'LineWidth', 2);
