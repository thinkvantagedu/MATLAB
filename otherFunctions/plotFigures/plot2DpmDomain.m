clc; clf; 
%% cantilever domain.
plotData;
% all x y points.
xAxisAll = canti.pmVal.comb.space(:, 4);
yAxisAll = canti.pmVal.comb.space(:, 5);
% non-combined x y points.
xAxis = canti.pmVal.i.space{:}(:, 2);
yAxis = canti.pmVal.damp.space(:, 2);
% coarse x y points.
xco = xAxis(1:8:end);
yco = yAxis(1:8:end);
% combined coarse x y points.
xyco = combvec(xco', yco')';
xAxisCo = xyco(:, 1);
yAxisCo = xyco(:, 2);
% corner vertices.
xcor = xco([1, end], :);
ycor = yco([1, end], :);
xycor = combvec(xcor', ycor')';
xAxisCor = [0.1 10];
yAxisCor = [0.1 10];

scatter(xAxisAll, yAxisAll, 20, 'filled', 'MarkerFaceColor', 'b')
hold on
scatter(xAxisCo, yAxisCo, 100, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k')
scatter(xAxisCor, yAxisCor, 320, 'd', 'MarkerFaceColor', 'y', 'MarkerEdgeColor', 'g')
axis square
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
set(gca,'fontsize', fsAll)
grid on
xlabel('Young''s Modulus', 'FontSize', fsAll);
ylabel('Damping Coefficient', 'FontSize', fsAll);
legend({'$P^{train}, 65 \times 65$', '$P^{train}_{co}, 9\times 9$', ...
    'Initial magic points'}, 'Interpreter', 'latex')

% %% fix beam domain.
% plotData;
% % all x y points.
% xAxisAll = fixie.pmVal.comb.space(:, 4);
% yAxisAll = fixie.pmVal.comb.space(:, 5);
% % non-combined x y points.
% xAxis = fixie.pmVal.i.space{:}(:, 2);
% yAxis = fixie.pmVal.damp.space(:, 2);
% % corner vertices.
% xcor = xAxis([1, 9, end], :);
% ycor = yAxis([1, 9, end], :);
% xycor = combvec(xcor', ycor')';
% xAxisCor = xycor(:, 1);
% yAxisCor = xycor(:, 2);
% 
% scatter(xAxisAll, yAxisAll, 80, 'filled', 'MarkerFaceColor', 'b')
% hold on
% scatter(xAxisCor, yAxisCor, 240, 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'r')
% axis square
% set(gca, 'xscale', 'log')
% set(gca, 'yscale', 'log')
% set(gca,'fontsize',fsAll)
% grid on
% xlabel('Young''s Modulus', 'FontSize', fsAll);
% ylabel('Damping Coefficient', 'FontSize', fsAll);
% legend({'$P^{train}, 17 \times 17$', '$P^{i}, 3\times 3$', }, 'Interpreter', 'latex')