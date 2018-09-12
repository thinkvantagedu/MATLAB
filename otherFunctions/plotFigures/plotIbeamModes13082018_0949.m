clear; clf;
plotData;
% this script plots deformations of modes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1/fixrb;
load('node.mat', 'node');
load('elem.mat', 'elem');
load('phiOri.mat', 'phiOri')
load('phiPro.mat', 'phiPro')
dis = reshape(phiPro(:, 15), [3, 3146]);
dis = dis';
scaleFactor = 2;
pdeplot3D(node + scaleFactor * log10(abs(dis')), elem, 'ColorMapData', ...
    log10(abs(dis(:, 2))));
cb = colorbar();
% cb.Ruler.Scale = 'log';
% set(cb, 'TickLabels', {'$10^{-14}$', '$10^{-12}$', '$10^{-10}$', ...
%     '$10^{-8}$', '$10^{-6}$', '$10^{-4}$', '$10^{-2}$'}, ...
%     'TickLabelInterpreter', 'latex')

set(cb, 'TickLabels', {'$10^{-9}$', '$10^{-8}$', '$10^{-7}$', ...
    '$10^{-6}$', '$10^{-5}$', '$10^{-4}$', '$10^{-3}$', '$10^{-2}$', ...
    '$10^{-1}$'}, ...
    'TickLabelInterpreter', 'latex')

colormap jet
axis image
set(gca, 'Zdir', 'reverse')
set(gca,'fontsize', 25)
caxis([-9.5, -0.5])
% colorbar off