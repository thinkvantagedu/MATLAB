function GSAPlotTwoDecayOverlap(err1, err2, plotName1, plotName2)
% plot two decay curves in the same figure. 

no_plot = length(err1);

% plot 1 
semilogy((1:no_plot), err1, 'b-^');
hold on

% plot 2
semilogy((1:no_plot), err2, 'k->')

% parameters
font_size.axis = 20;
grid on
set(gca, 'fontsize', font_size.axis)
xlim([1 no_plot])

% use the smaller err(end) as the end of y limit. 
if err1(end) < err2(end)
    ylim([err1(end), err1(1)])
else
    ylim([err2(end), err2(1)])
end

axis square
legend(plotName1, plotName2, 'Location', 'southwest')
xlabel('Greedy iterations')
ylabel('Maximum error')