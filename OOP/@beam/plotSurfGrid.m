function obj = plotSurfGrid(obj, drawRow, drawCol, gridSwitch, axisLim, ...
    originalSwitch)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch originalSwitch
    case 'original'
        obj.err.max.pass = obj.err.max.val.slct;
        obj.err.store.pass = obj.err.store.surf;
    case 'hhat'
        obj.err.max.pass = obj.err.max.val.hhat;
        obj.err.store.pass = obj.err.store.surf.hhat;
end
errMax = obj.err.max.pass;
errStore = obj.err.store.pass;

if gridSwitch == 1 % plot refined grid.
    iplot = 3 * obj.countGreedy - 2;
    hAx = subplot(drawRow, drawCol * 3, iplot);
    surf(linspace(obj.domBond.I1.L, obj.domBond.I1.R, obj.domLeng.I1), ...
        linspace(obj.domBond.I2.L, obj.domBond.I2.R, obj.domLeng.I2), ...
        errStore');
    view(3)
    txtPlotCurrentMax = sprintf('[%d %d]', obj.pmLoc.max(1), obj.pmLoc.max(2));
    text(obj.pmExpo.max(1), obj.pmExpo.max(2), errMax, txtPlotCurrentMax, ...
        'color', '[1 0.4 0.1]', 'Fontsize', 12);
    
    gridPos = get(hAx, 'position');
    gridPos(1) = gridPos(1) - 0.04;
    gridPos(2) = gridPos(2) - 0.12;
    gridPos(3) = gridPos(3) * 2.1;
    gridPos(4) = gridPos(4) * 2.1;
    set(hAx, 'position', gridPos)
    axi_lim = [0, axisLim];
    set(hAx,'zscale','log')
    axis(hAx,'square')
    axis(hAx,'tight', 'manual')
    keyboard
    scatHatHand = subplot(drawRow, drawCol * 3, 3 * obj.countGreedy - 1);
    plotGrid(obj, 'hat');
    scatHatPos = get(scatHatHand, 'position');
    scatHatPos(1) = scatHatPos(1) + 0.06;
    scatHatPos(2) = scatHatPos(2) + 0.2;
    scatHatPos(3) = scatHatPos(3) * 0.5;
    scatHatPos(4) = scatHatPos(4) * 0.5;
    set(scatHatHand, 'position', scatHatPos)
    grid on
    keyboard
    scatHhatHand = subplot(drawRow, drawCol * 3, 3 * obj.countGreedy);
    plotGrid(obj, 'hhat');
    scatHhatPos = get(scatHhatHand, 'position');
    scatHhatPos(1) = scatHhatPos(1) - 0.026;
    scatHhatPos(2) = scatHhatPos(2) + 0.1;
    scatHhatPos(3) = scatHhatPos(3) * 0.5;
    scatHhatPos(4) = scatHhatPos(4) * 0.5;
    set(scatHhatHand, 'position', scatHhatPos)
    grid on
    axis([obj.domBond.I1.L obj.domBond.I1.R obj.domBond.I2.L obj.domBond.I2.R])
    
elseif gridSwitch == 0
    
    switch originalSwitch
        case 'original'
            % case for callCantiOriginal.
            eLoc = obj.err.store.loc;
            eSurf = obj.err.store.surf;
        case 'hhat'
            % case for callCanti.
            eLoc = obj.err.store.loc.hhat;
            eSurf = obj.err.store.surf.hhat;
    end
    
    hAx = subplot(drawRow, drawCol, obj.countGreedy);
    
    if obj.no.inc == 1
        
        semilogy(obj.pmExpo.i{:}, eSurf, 'k');
        
        txtPlotCurrentMax = sprintf('[%d %g]', obj.pmLoc.max, ...
            obj.err.max.val.slct);
        errTxt = text(obj.pmExpo.max, errMax, txtPlotCurrentMax, ...
            'color', '[0 0 1]', 'Fontsize', 12);
        xlabel('Inclusion')
    elseif obj.no.inc == 2
        
        surf(linspace(obj.domBond.I1.L, obj.domBond.I1.R, obj.domLeng.I1), ...
            linspace(obj.domBond.I2.L, obj.domBond.I2.R, obj.domLeng.I2), ...
            errStore');
        
        view(3)
        colorbar('northoutside');
        
        txtPlotCurrentMax = sprintf('[%d %d, %g]', ...
            obj.pmLoc.max(1), obj.pmLoc.max(2), obj.err.max.val.slct);
        errTxt = text(obj.pmExpo.max(1), obj.pmExpo.max(2), errMax, txtPlotCurrentMax, ...
            'color', '[0 0 1]', 'Fontsize', 12);
        xlabel('I1')
        ylabel('I2')
        set(hAx,'zscale','log')
    else
        disp('number of inclusions exceeds 2')
    end
    uistack(errTxt, 'top')
    if obj.countGreedy > 1
        
        eLocPrevMax = eLoc(obj.countGreedy - 1, :);
        eValPrevMaxCurrent = eSurf(eLocPrevMax(1), eLocPrevMax(2));
        
        txtPlotPrevMax = sprintf('[%d %d, %g]', ...
            eLocPrevMax(1), eLocPrevMax(2), eValPrevMaxCurrent);
        
        pmExpoPrev1 = obj.pmExpo.I1(eLocPrevMax(1, 1));
        pmExpoPrev2 = obj.pmExpo.I2(eLocPrevMax(1, 2));
        text(pmExpoPrev1, pmExpoPrev2, eValPrevMaxCurrent, txtPlotPrevMax, ...
            'color', '[0 0 0]', 'Fontsize', 12);
        
    end
    alpha(0.7)
    axi_lim = [0, axisLim];
    axis(hAx,'square')
    axis(hAx,'tight', 'manual')
    grid on
    
end
% set(hAx,'zlim',axi_lim)
shading faceted
colormap(cool)
set(gca,'fontsize',12)
set(legend,'FontSize',12);