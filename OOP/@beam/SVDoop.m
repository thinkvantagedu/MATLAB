function [obj] = SVDoop(obj, type)
% perform SVD for controlled initial scheme and rb enrichment. 
switch type
    
    case 'rbCtrlInitial'
        Snap = obj.dis.trial;
        NPhi = obj.err.rbCtrlTrialNo;
    case 'rbEnrichment'
        Snap = obj.err.rbEnrichment;
        NPhi = 1;
end


[phi, ~, ~] = svd(Snap, 0);

phi = phi(:,1:NPhi);

switch type
    
    case 'rbCtrlInitial'
        obj.phi.val = phi;
    case 'rbEnrichment'
        obj.phi.rbEnrichment = phi;
        
end