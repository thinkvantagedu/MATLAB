clf; clear; clc;
cd ~/Desktop/Temp/thesisResults/12052018_2024+;
load('errOriginalStore.mat', 'errOriginalStore')
load('errProposedStore.mat', 'errProposedStore')

%% plot decay value curve.
errxOri = [4 6 8 10 13 14 18 20 24 34 39];
errOriMax = errOriginalStore.store.max;
errxPro = [4 7 8 10 12 14 22 26 30 33 38];
errProMax = errProposedStore.store.max.verify;

figure(1)
ha1 = semilogy(errxOri, errOriMax, 'b-o', 'MarkerSize', 10, 'lineWidth', 3);
grid on
hold on
ha2 = semilogy(errxPro, errProMax, 'r-+', 'MarkerSize', 10, 'lineWidth', 3);
grid on
legend({'Classical', 'Implemented'}, 'FontSize', 20);
ax1 = gca;
ax1.XColor = 'b';
ax1.XTick = errxOri;
xlabel('Total number of basis vectors (classical)', 'FontSize', 20);
ylabel('Maximum relative error', 'FontSize', 20);
set(gca,'fontsize',20)
% grid on
% ax2 = axes(...
%     'Position',       ax1.Position,...
%     'XAxisLocation',  'top',...
%     'Color',          'none',...
%     'YTick',          [],...
%     'XLim',           [0 39]);
%     'XTick',          errxPro);

% ax2.XColor = 'r';
% set(gca,'fontsize',20)
% xlabel('Total number of basis vectors (implemented)', 'FontSize', 20);
% grid on

% %% plot decay location curve.
% figure(2)
% pmSpaceOri = logspace(-1, 1, 129);
% pmSpacePro = logspace(-1, 1, 129);
% errPmLocOri = pmSpaceOri(errOriginalStore.loc);
% errPmLocPro = pmSpacePro(errProposedStore.store.loc.verify);
% loglog(errPmLocOri, errOriMax, 'b-o', 'MarkerSize', 10, 'LineWidth', 3)
% hold on
% loglog(errPmLocPro, errProMax129, 'r-+', 'MarkerSize', 10, 'LineWidth', 3)
% axis([10^-1 10^1 0 errOriMax(1)])
% grid on
% legend({'Classical', 'Implemented', 'Random'}, ...
%     'FontSize', 20);
% set(gca,'fontsize',20)
% xlabel('Parametric Domain', 'FontSize', 20);
% ylabel('Maximum relative error', 'FontSize', 20);