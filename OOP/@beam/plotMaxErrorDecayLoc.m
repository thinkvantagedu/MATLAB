function obj = plotMaxErrorDecayLoc(obj, errType, color, width)
switch errType
    case 'original'
        erry = obj.err.store.max;
        errx = obj.err.store.loc;
    case 'hhat'
        erry = obj.err.store.max.hhat;
        errx = obj.err.store.loc.hhat;
end
semilogy(errx, erry, color, 'LineWidth', width);
axis([1 obj.domLeng.i 0 erry(1)])
for i = 1:length(erry)
    stri = num2str(i);
    text(errx(i), erry(i), stri, 'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'bottom');
end
grid on

end