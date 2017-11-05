function GSAPlotDecay(err, plotName)

no_plot = length(err);

semilogy((1:no_plot), err, 'b-^');
font_size.axis = 20;
grid on
set(gca, 'fontsize', font_size.axis)
xlim([1 no_plot])
ylim([err(end), err(1)])
axis square
legend(plotName, 'Location', 'southwest')
xlabel('Greedy iterations')
ylabel('Maximum error')