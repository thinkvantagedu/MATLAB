function obj = plotSurfGrid(obj, typeSwitch, lineColor, damSwitch)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch typeSwitch
    case 'original'
        eMax = obj.err.max.realVal;
        eLocStore = obj.err.store.realLoc;
        eSurf = obj.err.store.surf;
        eMaxLocReal = obj.err.max.realLoc;
    case 'hhat'
        eMax = obj.err.max.val.hhat;
        eLocStore = obj.err.store.loc.hhat;
        eSurf = obj.err.store.surf.hhat;
        eMaxLocReal = obj.err.max.loc.hhat;
    case 'hat'
        eMax = obj.err.max.val.hat;
        eLocStore = obj.err.store.loc.hat;
        eSurf = obj.err.store.surf.hat;
        eMaxLocReal = obj.err.max.loc.hat;
end

if damSwitch == 0
    figure(1)
    % for single inclusion case, plot error response curve.
    loglog(obj.pmVal.i.space{:}(:, 2), eSurf, 'LineWidth', 2);
    txtMax = sprintf('[%d %.2g]', eMaxLocReal, eMax);
    text(obj.pmVal.comb.space(eMaxLocReal, 3), ...
        eMax, txtMax, 'color', '[0 0 0]', 'Fontsize', 20);
    if obj.countGreedy > 1
        
%         location of previous maximum error.
        eLocPrev = num2cell(eLocStore(obj.countGreedy - 1, :));
%         switch to index.
        eLocIdx = sub2ind(size(eSurf), eLocPrev{:});
%         value of previous maximum error location on current response surface.
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
    ey = obj.pmVal.damp.space(:, 2);
    surf(ex, ey, eSurf');
    txtMax = sprintf('[%d %d %.2g]', eMaxLocReal, eMax);
    text(obj.pmVal.realMax(1), obj.pmVal.realMax(2), eMax, ...
        txtMax, 'color', '[0 0 0]', 'Fontsize', 30);
%     set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale','log', ...
%         'dataaspectratio', [length(ey) length(ex) 1])
    set(gca, 'XScale', 'log', 'YScale', 'log', 'ZScale','log')
    shading interp
    view(3)
    
%     colorbar
    ylabel('Damping coefficient')
    zlabel('Maximum relative error')
    colormap(jet)
    axis square
end
xlabel('Youngs Modulus')

grid on
set(gca,'fontsize',20)
