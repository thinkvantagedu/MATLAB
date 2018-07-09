function obj = plotSurfGrid(obj, typeSwitch, lineColor, damSwitch)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch typeSwitch
    case 'original'
        eMax = obj.err.max.val;
        eLocStore = obj.err.store.realLoc;
        eSurf = obj.err.store.surf;
        eLocMaxMagic = obj.err.max.realLoc;
    case 'hhat'
        eMax = obj.err.max.val.hhat;
        eLocStore = obj.err.store.loc.hhat;
        eSurf = obj.err.store.surf.hhat;
        eLocMaxMagic = obj.err.max.loc.hhat;
    case 'hat'
        eMax = obj.err.max.val.hat;
        eLocStore = obj.err.store.loc.hat;
        eSurf = obj.err.store.surf.hat;
        eLocMaxMagic = obj.err.max.loc.hat;
end

if damSwitch == 0
    figure(1)
    % for single inclusion case, plot error response curve.
    loglog(obj.pmVal.i.space{:}(:, 2), eSurf, lineColor, 'LineWidth', 3);
    txtMax = sprintf('[%d %.2g]', eLocMaxMagic, eMax);
    text(obj.pmVal.max, eMax, txtMax, 'color', '[0 0 0]', 'Fontsize', 20);
    if obj.countGreedy > 1
        
        % location of previous maximum error.
        eLocPrev = num2cell(eLocStore(obj.countGreedy - 1, :));
        % switch to index.
        eLocIdx = sub2ind(size(eSurf), eLocPrev{:});
        % value of previous maximum error location on current response surface.
        eValPrevMaxCurrent = eSurf(eLocIdx);
        pmValPrev = obj.pmVal.i.space{:}(eLocPrev{:}, 2);
        txtPrevMax = sprintf('[%d %.2g]', eLocPrev{1}, eValPrevMaxCurrent);
        text(pmValPrev, eValPrevMaxCurrent, txtPrevMax, ...
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
    txtMax = sprintf('[%d %d %.2g]', eLocMaxMagic, eMax);
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
