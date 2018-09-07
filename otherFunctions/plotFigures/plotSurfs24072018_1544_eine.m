clear; clc; clf;
% this script plots error response surfaces to show how error in the error
% works. 
plotData;
cd ~/Desktop/Temp/thesisResults/24072018_1544_eine/uiTuj/;
load('n65ref2.mat', 'n65ref2')
np = 65;

ex = logspace(-1, 1, np);
eyhhat = n65ref2.store.surf.hhat;
eyhat = n65ref2.store.surf.hat;
eyori = n65ref2.store.surf.verify;

% max values.
emhhat = n65ref2.store.max.hhat;
emhat = n65ref2.store.max.hat;
emori = n65ref2.store.max.verify;
% max locations.
elhhat = ex(n65ref2.store.loc.hhat);
elhat = ex(n65ref2.store.loc.hat);
elori = ex(n65ref2.store.loc.verify(1));
% max texts.
tmhhat = sprintf('[%.3g %.3g]', elhhat, emhhat);
tmori = sprintf('[%.3g %.3g]', elori, emori);

plot(ex, eyhhat, 'b', 'LineWidth', lwOther);
hold on
plot(ex, eyhat, 'r', 'LineWidth', lwOther);
plot(ex, eyori, 'k', 'LineWidth', lwOther);
scatter(elhhat, emhhat, 200, 'b', 'Marker', '+', 'LineWidth', lwOther)
scatter(elori, emori, 200, 'k', 'Marker', '+', 'LineWidth', lwOther)
text(elhhat, emhhat, tmhhat, 'color', '[0 0 1]', 'FontSize', fsAll)
text(elori, emori, tmori, 'color', '[0 0 0]', 'FontSize', fsAll)
axis square
grid minor
xlabel('Youngs Modulus')
ylabel(yLab)
legend({'$\hat{\hat{e}}$', '$\hat{e}$', '$e$', '$\hat{\hat{e}}_{max}$',...
    '$e_{max}$'}, 'Interpreter', 'latex')
set(gca,'fontsize', 20, 'XScale', 'log', 'YScale', 'log')
axis square