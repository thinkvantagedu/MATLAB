function obj = plotMaxErrorDecayLoc(obj, errType, color, width, damSwitch)

switch errType
    case 'original'
        errx = obj.pmVal.i.space{:}(obj.err.store.realLoc, 2);
        erry = obj.err.store.max;
        xLocText = obj.err.store.realLoc;
    case 'verify'
        errx = obj.err.store.loc.verify(:, 2);
        erry = obj.err.store.max.verify;
        xLocText = obj.err.store.loc.verify;
end

figure
if damSwitch == 0
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
    
elseif damSwitch == 1
    
    ex = obj.pmVal.i.space{:}(:, 2);
    ey = obj.pmVal.damp.space(:, 2);
    eMx = ex(obj.err.store.realLoc(:, 1));
    eMy = ey(obj.err.store.realLoc(:, 2));
    eMz = obj.err.store.max;
    scatter3(eMx, eMy, eMz, 'filled', 'k')
    for iT = 1:length(eMx)
        
        text(eMx(iT), eMy(iT), eMz(iT), {' ', num2str(iT)}, 'Fontsize', 20);
        
    end
    exl = ex(1);
    exr = ex(end);
    eyl = ey(1);
    eyr = ey(end);
    axis([exl exr eyl eyr]);
    set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale','log', ...
        'dataaspectratio', [length(ey) length(ex) 1])
end

grid on
set(gca,'fontsize',20)
axis square

end