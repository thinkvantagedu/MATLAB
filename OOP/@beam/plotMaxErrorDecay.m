function obj = plotMaxErrorDecay(obj, err)
no_plot = length(err);

% semilogy((1:no_plot), err, 'b-*', 'DisplayName', 'Greedily selected samples', 'LineWidth', 2);
semilogy((1:no_plot), err, 'b-*', 'LineWidth', 2);
font_size.axis = 20;
grid on
set(gca, 'fontsize', font_size.axis)
xlim([1 no_plot])
% ylim([err(end), err(1)])
% axis square
% legend(plotName, 'Location', 'southwest')
xlabel('Greedy iterations')
ylabel('Maximum error')

% legend('show')
grid on
set(gca, 'FontSize', 25)
% legend('location', 'northeast')