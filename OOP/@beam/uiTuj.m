function obj = uiTuj(obj)
% an IMPORTANT difference from uiTui: no of calculations relates to no of
% blocks, not no of sample points.

if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % responses of these indices are needed: all hhat indices.
    idxCompute = obj.pmExpo.hhat(:, 1);
    nBlkComp = obj.no.block.hhat;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % responses of these indices are needed: newly added indices.
    idxAdd = cell2mat(obj.pmExpo.block.add);
    idxCompute = unique(idxAdd(:, 1));
    nBlkComp = obj.no.block.add + 1;
end

if obj.countGreedy == 1
    % initial Greedy there is no new response vectors. If countGreedy = 1,
    % there is no reuse of part 1.
    nVecNew = 0;
else
    % number of nre response vectors.
    nVecNew = obj.no.phy * obj.no.rbAdd * obj.no.t_step;
    eTeImporthhat = sortrows(obj.err.pre.hhat, 2);
    eTeImporthhat = eTeImporthhat(:, 6);
    eTeImporthat = sortrows(obj.err.pre.hat, 2);
    eTeImporthat = eTeImporthat(:, 6);
end

% for hhat, responses need to be chosen based on enrich or refine.
respStorehhat = obj.resp.store.all(idxCompute, :);
respSorthhat = sortrows(respStorehhat, 2);
% for hat, responses are all hat ones,
respStorehat = obj.resp.store.all(1:obj.no.pre.hat, :);
respSorthat = sortrows(respStorehat, 2);

nVecTot = numel(respSorthhat{1, 3});
nVecOld = nVecTot - nVecNew;

%% 1. compute uiTuj for ehat.
% ehat before ehhat because if refine, ehat is inherited from the previous
% ehhat. If calculate ehat after ehhat, ehat is inherited from the current
% ehhat.

% if initial, compute full for all blocks.
% if refine, inherit part 1 2 3 4 of all blocks from ehhat, no computation.
% if enrich, inherit part 1 from ehat, compute part 2 3 4 for all blocks.

% initial and enrich should be combined, by defining the new vecs and old
% vecs properly. So there is no initial when enrich.
respCell_ = cell(nBlkComp, 4);

if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % when enrich (initial or not), calculate part 1 2 3 4.
    for iPre = 1:obj.no.block.hat
        respExtOld = respSorthat{iPre, 3}(1:nVecOld);
        respExtNew = respSorthat{iPre, 3}(end - nVecNew + 1:end);
        respExtpOld = respSorthat{iPre + 1, 3}(1:nVecOld);
        respExtpNew = respSorthat{iPre + 1, 3}(end - nVecNew + 1:end);
        if obj.countGreedy == 1
            % if initial, re-compute eTe part 1.
            lu11 = eTePart(nVecOld, nVecOld, respExtOld, respExtpOld, 'rectangle');
            keyboard
        else
            % if enrich, inherit eTe part 1.
            lu11 = eTeImporthat{iPre};
            keyboard
        end
        % part 2: right upper block, full rectangle, unsymmetric (j from 1).
        ru12 = eTePart(nVecOld, nVecNew, respExtOld, respExtpNew, 'rectangle');
        % part 3: right lower block, right upper triangle, symmetric.
        rd22 = eTePart(nVecNew, nVecNew, respExtNew, respExtpNew, 'rectangle');
        % part 4: left lower block, rectangle all-zeros.
        ld21 = eTePart(nVecNew, nVecOld, respExtNew, respExtpOld, 'rectangle');
        
        % put part 1 2 3 4 together to form a triangular matrix.
        respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        respTrans = obj.resp.rv.L' * respTrans_ * obj.resp.rv.L;
        
        respCell_(iPre, 1) = {respSorthat{iPre, 1}};
        respCell_(iPre, 2) = {respSorthat{iPre, 2}};
        respCell_(iPre, 3) = {respTrans};
        respCell_(iPre, 4) = {respTrans_};
    end
    
    respCell_(nBlkComp, 1:2) = respSorthat(nBlkComp, 1:2);
    respCell_(nBlkComp, 3:4) = {[]};
    respCellSort = sortrows(respCell_, 1);
    obj.err.pre.hat(:, [4 6]) = respCellSort(:, 3:4);
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % if refine (initial or not), inherit from previous ehhat.
    obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);
    keyboard
end

%% 2. compute uiTuj for ehhat.
% if initial, compute full for all blocks.
% if refine, inherit the non-refined blocks from ehhat and compute full for
% refined blocks.
% if enrich, inherit part 1 from ehhat and compute part 2 3 4 for all blocks.
respCell_ = cell(nBlkComp + 1, 4);

for iPre = 1:nBlkComp
    
    respExtOld = respSorthhat{iPre, 3}(1:nVecOld);
    respExtNew = respSorthhat{iPre, 3}(end - nVecNew + 1:end);
    respExtpOld = respSorthhat{iPre + 1, 3}(1:nVecOld);
    respExtpNew = respSorthhat{iPre + 1, 3}(end - nVecNew + 1:end);
    
    % part 1: left upper block, right upper triangle, symmetric.
    if obj.countGreedy == 1 || obj.indicator.enrich == 0 && ...
            obj.indicator.refine == 1
        % if initial or refine, re-compute eTe part 1.
        lu11 = eTePart(nVecOld, nVecOld, respExtOld, respExtpOld, 'rectangle');
        keyboard
    elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
        % if enrich, inherit eTe part 1.
        lu11 = eTeImporthhat{iPre};
        keyboard
    end
    % part 2: right upper block, full rectangle, unsymmetric (j from 1).
    ru12 = eTePart(nVecOld, nVecNew, respExtOld, respExtpNew, 'rectangle');
    % part 3: right lower block, right upper triangle, symmetric.
    rd22 = eTePart(nVecNew, nVecNew, respExtNew, respExtpNew, 'rectangle');
    % part 4: left lower block, rectangle all-zeros.
    ld21 = eTePart(nVecNew, nVecOld, respExtNew, respExtpOld, 'rectangle');
    
    % put part 1 2 3 4 together to form a triangular matrix.
    respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
    respTrans = obj.resp.rv.L' * respTrans_ * obj.resp.rv.L;
    
    respCell_(iPre, 1) = {respSorthhat{iPre, 1}};
    respCell_(iPre, 2) = {respSorthhat{iPre, 2}};
    respCell_(iPre, 3) = {respTrans};
    respCell_(iPre, 4) = {respTrans_};
    
end

respCell_(nBlkComp + 1, 1:2) = respSorthhat(nBlkComp + 1, 1:2);
respCell_(nBlkComp + 1, 3:4) = {[]};
% indices of modified rows of responses.
respModIdx = [respCell_{:, 1}];
obj.err.pre.hhat(respModIdx(1:end - 1), [4 6]) = respCell_((1:end - 1), 3:4);
keyboard
end