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
    nNew = 0;
else
    % number of nre response vectors.
    nNew = obj.no.phy * obj.no.rbAdd * obj.no.t_step;
    eTeImport = sortrows(obj.err.pre.hhat, 2);
    eTeImport = eTeImport(:, 6);
end

respStore = obj.resp.store.all(idxCompute, :);
respSort = sortrows(respStore, 2);

for iPre = 1:nBlkComp
    
    nTot = numel(respSort{iPre, 3});
    nOld = nTot - nNew;
    respExtOld = respSort{iPre, 3}(1:nOld);
    respExtNew = respSort{iPre, 3}(end - nNew + 1:end);
    respExtpOld = respSort{iPre + 1, 3}(1:nOld);
    respExtpNew = respSort{iPre + 1, 3}(end - nNew + 1:end);
    
    % part 1: left upper block, right upper triangle, symmetric.
    if obj.countGreedy == 1 || obj.indicator.enrich == 0 && ...
            obj.indicator.refine == 1
        % if initial or refine, re-compute eTe part 1.
        lu11 = eTePart(nOld, nOld, respExtOld, respExtpOld, 'rectangle');
    elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
        % if enrich, inherit eTe part 1.
        lu11 = eTeImport{iPre};
    end
    % part 2: right upper block, full rectangle, unsymmetric (j from 1).
    ru12 = eTePart(nOld, nNew, respExtOld, respExtpNew, 'rectangle');
    % part 3: right lower block, right upper triangle, symmetric.
    rd22 = eTePart(nNew, nNew, respExtNew, respExtpNew, 'rectangle');
    % part 4: left lower block, rectangle all-zeros.
    ld21 = eTePart(nNew, nOld, respExtNew, respExtpOld, 'rectangle');
    
    % put part 1 2 3 4 together to form a triangular matrix.
    respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
    keyboard
end

end