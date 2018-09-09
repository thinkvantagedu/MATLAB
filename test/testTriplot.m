clear; clc; clf;
% nodal coordinates.
coord = [0 0; 1 0; 2 0; 3 0; 0 1; 0.5 1; 1.5 1; 2.5 1; 3 1];
% connectivity.
conne = [1 6 5; 1 2 6; 2 7 6; 2 3 7; 3 8 7; 3 4 8; 4 9 8];
% y-displacements
ydis = [0 0 0 0 0.1 0.2 0.3 0.2 0.1]';
% 
coord_dis = [coord(:, 1) coord(:, 2) - ydis];

trisurf(conne, coord_dis(:,1), coord_dis(:,2));
axis tight equal