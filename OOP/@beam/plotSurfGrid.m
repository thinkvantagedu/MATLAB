function obj = plotSurfGrid(obj, drawRow, drawCol, axisLim, ...
    originalSwitch, lineColor)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch originalSwitch
    case 'original'
        obj.err.max.pass = obj.err.max.val;
        obj.err.store.pass = obj.err.store.surf;
    case 'hhat'
        obj.err.max.pass = obj.err.max.val.hhat;
        obj.err.store.pass = obj.err.store.surf.hhat;
    case 'hat'
        obj.err.max.pass = obj.err.max.val.hat;
        obj.err.store.pass = obj.err.store.surf.hat;
end
errMax = obj.err.max.pass;
errStore = obj.err.store.pass;

switch originalSwitch
    case 'original'
        % case for callCantiOriginal.
        eLoc = obj.err.store.loc;
        eSurf = obj.err.store.surf;
    case 'hhat'
        % case for callCanti.
        eLoc = obj.err.store.loc.hhat;
        eSurf = obj.err.store.surf.hhat;
    case 'hat'
        % case for callCanti.
        eLoc = obj.err.store.loc.hat;
        eSurf = obj.err.store.surf.hat;
end

if obj.no.inc == 1
    
    % for single inclusion case, plot error response curve.
    hAx = semilogy(obj.pmExpo.i{:}, eSurf, lineColor, 'LineWidth', 1);
    
    % text of current maximum error.
    switch originalSwitch
        case 'original'
            eMaxVal = obj.err.max.val;
        case 'hhat'
            eMaxVal = obj.err.max.val.hhat;
        case 'hat'
            eMaxVal = obj.err.max.val.hat;
    end
    txtPlotCurrentMax = sprintf('[%d %.2g %d]', obj.pmLoc.max, eMaxVal, ...
        obj.countGreedy);
    % add text to figure location.
    errTxt = text(obj.pmExpo.max{:}, errMax, txtPlotCurrentMax, ...
        'color', '[0 0 0]', 'Fontsize', 10);
    
    xlabel('Youngs Modulus')
    ylabel('Error')
    hold on
    axis square
    
elseif obj.no.inc == 2
    hAx = subplot(drawRow, drawCol, obj.countGreedy);
    % for double inclusion case, plot error response surface.
    surf(linspace(obj.domBond.i{1}(1), obj.domBond.i{1}(2), ...
        obj.domLeng.i(1)), ...
        linspace(obj.domBond.i{2}(1), obj.domBond.i{2}(2), ...
        obj.domLeng.i(2)), errStore');
    % text of current maximum error.
    txtPlotCurrentMax = sprintf('[%d %d, %d]', ...
        obj.pmLoc.max(1), obj.pmLoc.max(2), obj.err.max.val.slct);
    % add text to figure location.
    errTxt = text(obj.pmExpo.max{:}, errMax, ...
        txtPlotCurrentMax, 'color', '[0 0 0]', 'Fontsize', 20);
    xlabel('I1')
    ylabel('I2')
    set(hAx,'zscale','log')
    view(3)
    colorbar('northoutside');
    axis(hAx,'square')
    axis(hAx,'tight', 'manual')
else
    disp('number of inclusions exceeds 2')
end
uistack(errTxt, 'top')

if obj.countGreedy > 1
    % location of previous maximum error.
    eLocPrevMax = num2cell(eLoc(obj.countGreedy - 1, :));
    % switch to index.
    eLocIdx = sub2ind(size(eSurf), eLocPrevMax{:});
    % value of previous maximum error location on current response
    % surface.
    eValPrevMaxCurrent = eSurf(eLocIdx);
    pmExpoPrev = [];
    for i = 1:obj.no.inc
        pmExpoPrev = [pmExpoPrev, obj.pmExpo.i{i}(eLocPrevMax{i})];
    end
    if obj.no.inc == 1
        txtPlotPrevMax = sprintf('[%d %.2g]', eLocPrevMax{1}, ...
            eValPrevMaxCurrent);
        text(pmExpoPrev, eValPrevMaxCurrent, txtPlotPrevMax, ...
            'color', '[1 0 1]', 'Fontsize', 10);
    elseif obj.no.inc == 2
        txtPlotPrevMax = sprintf('[%d %d, %d]', ...
            eLocPrevMax{1}, eLocPrevMax{2}, eValPrevMaxCurrent);
        text(pmExpoPrev(1), pmExpoPrev(2), eValPrevMaxCurrent, ...
            txtPlotPrevMax, 'color', '[0 0 1]', 'Fontsize', 20);
    else
        disp('number of inclusions exceeds 2')
    end
    axis tight
    
end
alpha(0.7)
axi_lim = [0, axisLim];

grid on

% set(hAx,'zlim',axi_lim)
shading faceted
colormap(cool)
set(gca,'fontsize',20)
% set(legend,'FontSize',20);
