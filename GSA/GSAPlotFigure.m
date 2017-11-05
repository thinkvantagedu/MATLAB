function surface = GSAPlotFigure(font_size, draw, i_cnt, domain, pmLoc, pmExp, ...
    axisLim, err, colormap_name, view_angle, gridSwitch)
% This function plots error response surface, err.store.val is the surface
% to be plotted. The location of the maximum error is also marked on the
% surface.

% font_size.label = 20;
% font_size.axis = 12;

figure(1)

if gridSwitch == 1 % plot refined grid.
    
    surface.hand = subplot(draw.row, draw.col * 3, 3 * i_cnt - 2);
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), ...
        err.store.val');
    surface.pos = get(surface.hand, 'position');
    surface.pos(1) = surface.pos(1) - 0.04;
    surface.pos(2) = surface.pos(2) - 0.12;
    surface.pos(3) = surface.pos(3) * 2.1;
    surface.pos(4) = surface.pos(4) * 2.1;
    set(surface.hand, 'position', surface.pos)
    set(gca, 'ZScale', 'log')
    
    axi_lim = [0, axisLim];
    zlim(axi_lim)
    axis tight
    axis square
    
    shading faceted
    colormap(colormap_name)
    grid on
    set(gca,'fontsize',font_size.axis)
    % xlabel('I1', 'FontSize', font_size.label)
    % ylabel('I2', 'FontSize', font_size.label)
    % zlabel('error', 'FontSize', font_size.label)
    
    %     txt_plot = sprintf('[%d %d];  %.2d', pmLoc.max.I1, pmLoc.max.I2, ...
    %         err.max.val);
    txt_plot = sprintf('[%d %d]', pmLoc.max.I1, pmLoc.max.I2);
    text(pmExp.max.ori.I1, pmExp.max.ori.I2, err.max.val, txt_plot, ...
        'color', '[1 0.4 0.1]', 'Fontsize', font_size.axis);
    
    axis([1 2 1 2])
    
    view([view_angle.x view_angle.y])
    set(legend,'FontSize',font_size.axis);
    
    scat.hat.hand = subplot(draw.row, draw.col * 3, 3 * i_cnt - 1);
    PlotLocalRefiGridwithIndex(pmExp.pre.block.hat)
    scat.hat.pos = get(scat.hat.hand, 'position');
    scat.hat.pos(1) = scat.hat.pos(1) + 0.04;
    scat.hat.pos(2) = scat.hat.pos(2) + 0.2;
    scat.hat.pos(3) = scat.hat.pos(3) * 0.5;
    scat.hat.pos(4) = scat.hat.pos(4) * 0.5;
    set(scat.hat.hand, 'position', scat.hat.pos)
    
    scat.hhat.hand = subplot(draw.row, draw.col * 3, 3 * i_cnt);
    PlotLocalRefiGridwithIndex(pmExp.pre.block.hhat)
    scat.hhat.pos = get(scat.hhat.hand, 'position');
    scat.hhat.pos(1) = scat.hhat.pos(1) - 0.026;
    scat.hhat.pos(2) = scat.hhat.pos(2) + 0.1;
    scat.hhat.pos(3) = scat.hhat.pos(3) * 0.5;
    scat.hhat.pos(4) = scat.hhat.pos(4) * 0.5;
    set(scat.hhat.hand, 'position', scat.hhat.pos)
    
elseif gridSwitch == 0
    
    subplot(draw.row, draw.col, i_cnt);
    
    surf(linspace(domain.bond.L.I1, domain.bond.R.I1, domain.length.I1), ...
        linspace(domain.bond.L.I2, domain.bond.R.I2, domain.length.I2), ...
        err.store.val');
    
    set(gca, 'ZScale', 'log')
    
    axi_lim = [0, axisLim];
    zlim(axi_lim)
    axis tight
    axis square
    
    shading faceted
    colormap(colormap_name)
    grid on
    set(gca,'fontsize',font_size.axis)
    % xlabel('I1', 'FontSize', font_size.label)
    % ylabel('I2', 'FontSize', font_size.label)
    % zlabel('error', 'FontSize', font_size.label)
    
    txt_plot = sprintf('[%d %d];  %.2d', pmLoc.max.I1, pmLoc.max.I2, ...
        err.max.val);
    text(pmExp.max.ori.I1, pmExp.max.ori.I2, err.max.val, txt_plot, ...
        'color', '[1 0.4 0.1]', 'Fontsize', font_size.axis);
    
    axis([1 2 1 2])
    
    view([view_angle.x view_angle.y])
    set(legend,'FontSize',font_size.axis);
    
end