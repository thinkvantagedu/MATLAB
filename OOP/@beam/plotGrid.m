function obj = plotGrid(obj, type)
% plot the scatter for grid domain, input needs to be a number of cell
% blocks with related index in the first column. Corresonding index is
% labelled on the right up corner of the grid. 
switch type
    case 'hat'
        inpt = obj.pmExpo.block.hat;
    case 'hhat'
        inpt = obj.pmExpo.block.hhat;
end
for iScat = 1:length(inpt)
    
    for jScat = 1:4
        
        scatter(inpt{iScat}(jScat, 2), inpt{iScat}(jScat, 3), 30, 'filled');
%         text(inpt{iScat}(jScat, 2) + dx, inpt{iScat}(jScat, 3) + dy, ...
%             num2str(inpt{iScat}(jScat, 1)));
        hold on
    end
    
end
axis square