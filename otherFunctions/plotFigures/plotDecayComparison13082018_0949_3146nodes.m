clear; clc; clf;
plotData;
% this script plots figures of I beam 3146 nodes.
%% part 1:convergence.
cd ~/Desktop/Temp/thesisResults/13082018_0949_Ibeam/3146nodes/trial=1089;
load('errOriginal.mat', 'errOriginal')
load('errProposedNouiTujN20.mat', 'errProposedNouiTujN20')

nInit = 2;
nAdd = 2;
nRb = 20;
errx = (nInit:nAdd:nRb);
errOriMax = errOriginal.store.realMax;

% extract error values at proposed magic points.
% manually find location of ehhat in original.

% errProLoc = [5 1; 9 1; 9 1; 1 1; 9 1; 1 1; 9 1; 9 1; 9 1; 9 9]; % for trial = 1
% errProLoc = [1 1; 1 1; 1 9; 1 9; 5 1; 9 1; 9 1; 9 1; 1 1; 9 1]; % for trial = 1089
% 
% errProMax = zeros(length(errProLoc), 1);
% for ip = 1:length(errProLoc)
%     
%     errLoc = errProLoc(ip, :);
%     errProMax(ip) = errProMax(ip) + errOriginal.store.allSurf{ip}(errLoc(1), errLoc(2));
%     
% end
% 
% % errProMax = errProposedNouiTujN20.store.max.hhat;
% 
% figure(1)
% semilogy(errx, errOriMax, 'b-o', 'MarkerSize', msAll, 'lineWidth', lwAll);
% hold on
% semilogy(errx, errProMax, 'r-^', 'MarkerSize', msAll, 'lineWidth', lwAll);
% 
% xticks(errx);
% axis([0 nRb -inf inf]);
% axis normal
% grid on
% legend({stStr, proStr}, 'FontSize', fsAll);
% set(gca,'fontsize',fsAll)
% xlabel(xLab, 'FontSize', fsAll);
% ylabel(yLab, 'FontSize', fsAll);

%% part 2: execution time.
