function obj = plotMaxErrorDecayLoc(obj, errType, color, width)
switch errType
    case 'original'
        erry = obj.err.store.max;
        errx = obj.err.store.loc;
    case 'hhat'
        erry = obj.err.store.max.hhat;
        errx = obj.err.store.loc.hhat;
    case 'verify'
        erry = obj.err.store.max.verify;
        errx = obj.err.store.loc.verify;
end
semilogy(errx, erry, color, 'LineWidth', width);
hold on
axis([1 obj.domLeng.i 0 erry(1)])
for i = 1:length(erry)
    stri = strcat(num2str(erry(i)), {' at sample '}, num2str(errx(i)));
    text(errx(i), erry(i), stri, 'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'bottom', 'FontSize', 20);
end
xlabel('Youngs Modulus')
ylabel('Maximum Relative Error')
grid on
set(gca,'fontsize',20)
axis square
end