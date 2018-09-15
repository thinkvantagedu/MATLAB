clf;
plotData;
% this script plots deformations of modes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('node.mat', 'node');
load('elem.mat', 'elem');
load('phiOri.mat', 'phiOri')
load('phiPro.mat', 'phiPro')
nd = length(phiOri) / 3;
ne = length(elem);
% load('phiPro.mat', 'phiPro')
nv = 4;
disOri = reshape(phiOri(:, nv), [3, nd]);
disPro = reshape(phiPro(:, nv), [3, nd]);
scaleFactor = 500;
node = node(:, 2:end);
elem = [elem(:, 2:end), zeros(ne, 1)];
figure(1)
pdeplot3D(node' + scaleFactor * disOri, elem', 'ColorMapData', disOri(2, :)');
view([90, 0])
colormap jet
axis image
set(gca, 'Ydir', 'reverse')
set(gca,'fontsize', 25)
figure(2)
pdeplot3D(node' + scaleFactor * disPro, elem', 'ColorMapData', disPro(2, :)');
cb = colorbar();
% cb.Ruler.Scale = 'log';
% set(cb, 'TickLabels', {'$10^{-14}$', '$10^{-12}$', '$10^{-10}$', ...
%     '$10^{-8}$', '$10^{-6}$', '$10^{-4}$', '$10^{-2}$'}, ...
%     'TickLabelInterpreter', 'latex')

% set(cb, 'TickLabels', {'$10^{-9}$', '$10^{-8}$', '$10^{-7}$', ...
%     '$10^{-6}$', '$10^{-5}$', '$10^{-4}$', '$10^{-3}$', '$10^{-2}$', ...
%     '$10^{-1}$'}, ...
%     'TickLabelInterpreter', 'latex')
view([90, 0])
colormap jet
axis image
set(gca, 'Ydir', 'reverse')
set(gca,'fontsize', 25)
% caxis([-9.5, -0.5])
% colorbar off