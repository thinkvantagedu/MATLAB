function obj = plotSurfGrid(obj, typeSwitch, lineColor, damSwitch)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch typeSwitch
    case 'original'
        eMax = obj.err.max.val;
        eLoc = obj.err.store.loc;
        eSurf = obj.err.store.surf;
    case 'hhat'
        eMax = obj.err.max.val.hhat;
        eLoc = obj.err.store.loc.hhat;
        eSurf = obj.err.store.surf.hhat;
    case 'hat'
        eMax = obj.err.max.val.hat;
        eLoc = obj.err.store.loc.hat;
        eSurf = obj.err.store.surf.hat;
end


if damSwitch == 0
    figure(1)
    % for single inclusion case, plot error response curve.
    semilogy(obj.pmExpo.i{:}, eSurf, lineColor, 'LineWidth', 3);
    txtMax = sprintf('[%d %.2g]', obj.err.max.loc, eMax);
    text(obj.pmExpo.max, eMax, txtMax, 'color', '[0 0 0]', 'Fontsize', 20);
    if obj.countGreedy > 1
        
        % location of previous maximum error.
        eLocPrev = num2cell(eLoc(obj.countGreedy - 1, :));
        % switch to index.
        eLocIdx = sub2ind(size(eSurf), eLocPrev{:});
        % value of previous maximum error location on current response surface.
        eValPrevMaxCurrent = eSurf(eLocIdx);
        pmExpoPrev = obj.pmExpo.i{:}(eLocPrev{:});
        txtPrevMax = sprintf('[%d %.2g]', eLocPrev{1}, ...
            eValPrevMaxCurrent);
        text(pmExpoPrev, eValPrevMaxCurrent, txtPrevMax, ...
            'color', '[1 0 1]', 'Fontsize', 20);
        axis tight
    end
    
    ylabel('Maximum relative error')
    hold on
    axis square
elseif damSwitch == 1
    figure
    ex = obj.pmVal.i.space{:}(:, 2);
    ey = obj.pmVal.damp.space(:, 3);
    surf(ex, ey, eSurf');
    txtMax = sprintf('[%d %d %.2g]', obj.err.max.loc, eMax);
    text(obj.pmVal.max(1), obj.pmVal.max(2), eMax, ...
        txtMax, 'color', '[0 0 0]', 'Fontsize', 20);
    set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale','log', ...
        'dataaspectratio', [length(ey) length(ex) 1])
    shading interp
    view(2)
    
    colorbar
    ylabel('Damping coefficient')
    zlabel('Maximum relative error')
    colormap(jet)
    
end
xlabel('Youngs Modulus')

grid on
set(gca,'fontsize',20)
