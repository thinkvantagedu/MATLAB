function obj = plotMaxErrorDecayVal(obj, errType, color, width, randomSwitch)
errx = obj.no.store.rb;

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
axis([0 inf 0 erry(1)])
% for i = 1:length(erry)
%     stri = strcat(num2str(erry(i)), {', '}, num2str(xLocText(i)));
%     text(errx(i), erry(i), stri, 'HorizontalAlignment', 'left', ...
%      'VerticalAlignment', 'bottom', 'FontSize', 20);
% end


if randomSwitch == 0
    xticks(errx);
elseif randomSwitch == 1
    
end

xlabel('N')
ylabel('Maximum error')

grid on
set(gca, 'FontSize', 20)
axis square

end