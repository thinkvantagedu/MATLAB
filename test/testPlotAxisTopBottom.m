clear; clc; clf
x1 = [1 3 5 7];
y1 = [1 4 3 5];

semilogy(x1, y1, 'Color', 'r')
ax1 = gca; % current axes
ax1.XColor = 'r';
ax1.YColor = 'r';
ax1.XTick = x1;

hold on
x2 = [1 2 4 7];
y2 = [4 3 2 1];
semilogy(x2, y2, 'Color', 'k')
ax1Pos = ax1.Position;
ax2 = axes('Position',ax1Pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
% ax2.XTick = x2;
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');


% line(x2,y2,'Color','k')
% ax3 = gca;
% ax3_pos = ax3.Position; % position of first axes
% ax4 = axes('Position',ax3_pos,...
%     'XAxisLocation','bottom',...
%     'Color','none', ...
%     'XTick', x1);
grid on

