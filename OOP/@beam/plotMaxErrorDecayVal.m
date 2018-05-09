function obj = plotMaxErrorDecayVal(obj, errType, color, width)
errx = obj.no.store.rb(2:end);

switch errType
    case 'original'
        erry = obj.err.store.max;
        xLocText = obj.err.store.loc;
    case 'hhat'
        erry = obj.err.store.max.hhat;
    case 'verify'
        erry = obj.err.store.max.verify;
        xLocText = obj.err.store.loc.verify;
end

semilogy(errx, erry, color, 'lineWidth', width);
hold on

% for i = 1:length(erry)
%     stri = strcat(num2str(erry(i)), {', '}, num2str(xLocText(i)));
%     text(errx(i), erry(i), stri, 'HorizontalAlignment', 'left', ...
%      'VerticalAlignment', 'bottom', 'FontSize', 20);
% end


xlim([0 inf])
% xlim([0 obj.no.rb])
% ylim([erry(end), erry(1)])
xticks(errx);

xlabel('N')
ylabel('Maximum error')

grid on
set(gca, 'FontSize', 20)
axis square

end