function obj = plotMaxErrorDecayVal(obj, errType, color, width, nPhiInitial)
switch errType
    case 'original'
        err = obj.err.store.max;
    case 'hhat'
        err = obj.err.store.max.hhat;
end
no_plot = length(err);
figure
% semilogy((1:no_plot), err, 'b-*', 'DisplayName', 'Greedily selected samples', 'LineWidth', 2);
semilogy((nPhiInitial:obj.no.rbAdd:obj.no.rb), err, color, 'lineWidth', width);
font_size.axis = 20;
grid on
set(gca, 'fontsize', font_size.axis)
xlim([0 obj.no.rb])
% ylim([err(end), err(1)])
% axis square
% legend(plotName, 'Location', 'southwest')
xlabel('N')
ylabel('Maximum error')

% legend('show')
grid on
set(gca, 'FontSize', 25)
% legend('location', 'northeast')
end