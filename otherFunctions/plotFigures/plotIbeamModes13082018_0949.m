clear; clf;
plotData;
% this script plots deformations of modes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/fixrb;
load('node.mat', 'node');
load('elem.mat', 'elem');
load('phiOri.mat', 'phiOri')

dis = reshape(phiOri(:, 1), [3, 3146]);
dis = dis';
scaleFactor = 1;
pdeplot3D(node, elem, 'ColorMapData', abs(dis(:, 2)));
colormap jet
axis image