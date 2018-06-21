clear; clc;
% this script plots ONERA OA209 airfoil wing section.

cd /home/xiaohan/Desktop/Temp/AbaqusModels/airfoil/Plots/;
fileID = fopen('OA209_CrossSection.txt', 'r');
coord = fscanf(fileID, '%f');

sec1 = coord(1:length(coord) / 2);
sec1 = reshape(sec1, [2, length(coord) / 4]);
sec1 = sec1';

scatter(sec1(:, 1), sec1(:, 2), 'filled');
hold on

sec2 = coord(length(coord) / 2 + 1 : end);
sec2 = reshape(sec2, [2, length(coord) / 4]);
sec2 = sec2';

scatter(sec2(:, 1), sec2(:, 2), 'filled');
axis equal