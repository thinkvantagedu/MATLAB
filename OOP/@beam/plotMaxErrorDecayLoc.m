function obj = plotMaxErrorDecayLoc(obj, errType, color, width)


switch errType
    case 'original'
        errx = obj.pmVal.i.space{:}(obj.err.store.loc, 2);
        erry = obj.err.store.max;
        xLocText = obj.err.store.loc;
    case 'hhat'
        erry = obj.err.store.max.hhat;
    case 'verify'
        errx = obj.err.store.loc.verify(:, 2);
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


xlabel('Youngs Modulus')
ylabel('Maximum Relative Error')

grid on
set(gca,'fontsize',20)
axis square

end