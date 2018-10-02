clf;
plotData;
% this script plots deformations of modes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=1;
load('errOriginalIter20Add2.mat', 'errOriginalIter20Add2')
load('errProposedNouiTujN20Iter20Add2.mat', ...
    'errProposedNouiTujN20Iter20Add2')
load('node.mat', 'node');
load('elem.mat', 'elem');
phiOri = errOriginalIter20Add2.phi.val;
phiPro = errProposedNouiTujN20Iter20Add2.phi.val;
% load('phiOri.mat', 'phiOri')
% load('phiPro.mat', 'phiPro')
nd = length(phiOri) / 3;
ne = length(elem);
nv = 4;
disOri = reshape(phiOri(:, nv), [3, nd]);
disPro = reshape(phiPro(:, nv), [3, nd]);
scaleFactor = 500;
node = node(:, 2:end);
elem = [elem(:, 2:end), zeros(ne, 1)];
figure(1)
pdeplot3D(node' + scaleFactor * disOri, elem')
hold on
pdeplot3D(node' + scaleFactor * disOri, elem', 'ColorMapData', disOri(2, :)');

view([90, 0])
% view(3)
colormap jet
axis image
set(gca, 'Ydir', 'reverse')
set(gca,'fontsize', 25)
caxis([-0.05, 0.07])
camroll(-90)
colorbar off


figure(2)
pdeplot3D(node' + scaleFactor * disPro, elem')
hold on
pdeplot3D(node' + scaleFactor * disPro, elem', 'ColorMapData', disPro(2, :)');
cb = colorbar();
view([90, 0])
% view(3)
colormap jet
axis image
set(gca, 'Ydir', 'reverse')
set(gca,'fontsize', 25)
caxis([-0.05, 0.07])
colorbar off
camroll(-90)