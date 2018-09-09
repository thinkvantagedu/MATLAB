clear; clc; clf;
% this script plots error response surfaces to show how error in the error
% works. 
plotData;
cd ~/Desktop/Temp/thesisResults/24072018_1544_eine/uiTuj/;
load('n65ref1.mat', 'n65ref1')
np = 65;

ex = logspace(-1, 1, np);
eyhhat = n65ref1.store.surf.hhat;
eyhat = n65ref1.store.surf.hat;
eyori = n65ref1.store.surf.verify;

% max values.
emhhat = n65ref1.store.max.hhat;
emhat = n65ref1.store.max.hat;
emori = n65ref1.store.max.verify;
% max locations.
elhhatn = n65ref1.store.loc.hhat;
elorin = n65ref1.store.loc.verify(1);
elhhat = ex(elhhatn);
elori = ex(elorin);
% max texts.
tmhhat = sprintf('[%g, %.3g, %.3g]', elhhatn, elhhat, emhhat);
tmori = sprintf('[%g, %.3g, %.3g]', elorin, elori, emori);

% itpl domain.
nitpl = 3;
exhh = [0.1 1 10];
eyhh = [0.01 0.01 0.01];
% nitpl = 4;
% exhh = [0.1 1 10^0.5 10];
% eyhh = [0.01 0.01 0.01 0.01];
% nitpl = 5;
% exhh = [0.1 1 10^0.5 10^0.75 10];
% eyhh = [0.01 0.01 0.01 0.01 0.01];


plot(ex, eyhhat, 'b-+', 'LineWidth', lwOther);
hold on
plot(ex, eyhat, 'r-+', 'LineWidth', lwOther);
plot(ex, eyori, 'k', 'LineWidth', lwOther);
scatter(elhhat, emhhat, 200, 'b', 'Marker', '+', 'LineWidth', lwOther)
scatter(elori, emori, 200, 'k', 'Marker', '+', 'LineWidth', lwOther)
scatter(exhh, eyhh, 200, 'b', 'filled', 'LineWidth', lwOther)
text(elhhat, emhhat, tmhhat, 'color', '[0 0 1]', 'FontSize', fsAll)
text(elori, emori, tmori, 'color', '[0 0 0]', 'FontSize', fsAll)
axis square
grid minor
xlabel('Youngs Modulus')
ylabel(yLab)
xticks(exhh)
legend({'$\hat{\hat{e}}$', '$\hat{e}$', '$e$', '$\hat{\hat{e}}_{max}$',...
    '$e_{max}$', '$\mu_i$'}, 'Interpreter', 'latex')
set(gca,'fontsize', 20, 'XScale', 'log', 'YScale', 'log')
axis square
ylim([10^-2 10^0])

cd ~/Desktop/Temp/Documents/Thesis/figures/24072018_1544/;