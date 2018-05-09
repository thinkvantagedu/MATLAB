function obj = plotMaxErrorDecayLoc(obj, errType, color, width)
errx = [obj.err.store.redInfo{3:end, 2}];

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

loglog(errx, erry, color, 'LineWidth', width);
hold on
axis([10 ^ obj.domBond.i{:}(1) 10 ^ obj.domBond.i{:}(2) 0 erry(1)])
for i = 1:length(erry)
    stri = strcat(num2str(erry(i)), {', '}, num2str(xLocText(i)));
    text(errx(i), erry(i), stri, 'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'bottom', 'FontSize', 20);
end




% ylim([erry(end), erry(1)])
xlabel('Youngs Modulus')
ylabel('Maximum Relative Error')

grid on
set(gca,'fontsize',20)
axis square

end