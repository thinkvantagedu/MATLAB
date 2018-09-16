clc; clf; 
%% cantilever domain.
plotData;
% all x y points.
xAxisAll = canti.pmVal.comb.space(:, 4);
yAxisAll = canti.pmVal.comb.space(:, 5);
% non-combined x y points.
xAxis = canti.pmVal.i.space{:}(:, 2);
yAxis = canti.pmVal.damp.space(:, 2);

% plot interpolation samples for trial = 1 and 4225.
cd ~/Desktop/Temp/thesisResults/13092018_2218_Ibeam/trial=4225;
load('pmValHhat', 'pmValHhat')
xhhat = pmValHhat(:, 2);
yhhat = pmValHhat(:, 3);

scatter(xAxisAll, yAxisAll, 15, 'filled', 'MarkerFaceColor', '[0.4 0.6 0.7]')
hold on
scatter(xhhat, yhhat, 20, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'y')

axis square
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
set(gca,'fontsize', fsAll)
grid on
xlabel('Young''s Modulus', 'FontSize', fsAll);
ylabel('Damping Coefficient', 'FontSize', fsAll);
legend({'$P^{train}, 65 \times 65$', '$\hat{\hat{P^i}}$'}, ...
    'Interpreter', 'latex')
