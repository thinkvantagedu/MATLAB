clear; clc;
% test contour plot.
%// example 2D smooth data
x = conv2( randn(600), fspecial('gaussian',200,20), 'valid'); 
imagesc(x)
colormap(jet)
colorbar