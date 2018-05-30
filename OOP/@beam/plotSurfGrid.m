function obj = plotSurfGrid(obj, typeSwitch, lineColor)
% This function plots error response surface for the desired cases.
% The location of the maximum error is also marked on the surface.
switch typeSwitch
    case 'original'
        errMax = obj.err.max.val;
        eLoc = obj.err.store.loc;
        eSurf = obj.err.store.surf;
    case 'hhat'
        errMax = obj.err.max.val.hhat;
        eLoc = obj.err.store.loc.hhat;
        eSurf = obj.err.store.surf.hhat;
    case 'hat'
        errMax = obj.err.max.val.hat;
        eLoc = obj.err.store.loc.hat;
        eSurf = obj.err.store.surf.hat;
end

% for single inclusion case, plot error response curve.
hAx = semilogy(obj.pmExpo.i{:}, eSurf, lineColor, 'LineWidth', 3);

txtCurrentMax = sprintf('[%d %.2g]', obj.pmLoc.max, errMax);
% add text to figure location.
errTxt = text(obj.pmExpo.max{:}, errMax, txtCurrentMax, ...
    'color', '[0 0 0]', 'Fontsize', 20);

xlabel('Youngs Modulus')
ylabel('Maximum relative error')
hold on
axis square

% if obj.countGreedy > 1
%     
%     % location of previous maximum error.
%     eLocPrevMax = num2cell(eLoc(obj.countGreedy - 1, :));
%     % switch to index.
%     eLocIdx = sub2ind(size(eSurf), eLocPrevMax{:});
%     % value of previous maximum error location on current response
%     % surface.
%     eValPrevMaxCurrent = eSurf(eLocIdx);
%     pmExpoPrev = [];
%     for i = 1:obj.no.inc
%         pmExpoPrev = [pmExpoPrev, obj.pmExpo.i{i}(eLocPrevMax{i})];
%     end
%     txtPlotPrevMax = sprintf('[%d %.2g]', eLocPrevMax{1}, ...
%         eValPrevMaxCurrent);
%     text(pmExpoPrev, eValPrevMaxCurrent, txtPlotPrevMax, ...
%         'color', '[1 0 1]', 'Fontsize', 20);
%     
%     axis tight
%     
% end

grid on
shading faceted
colormap(cool)
set(gca,'fontsize',20)
