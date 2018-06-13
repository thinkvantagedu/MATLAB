function obj = uiTujDamping(obj)
% an IMPORTANT difference from uiTui: no of calculations relates to no of
% blocks, not no of sample points.
disp('uiTuj starts')

tic
pmExpoBlkhat = obj.pmExpo.block.hat;
nBlkhat = obj.no.block.hat;
pmExpoBlkhhat = obj.pmExpo.block.hhat;
nBlkhhat = obj.no.block.hhat;

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

if obj.countGreedy == 0
    % initial Greedy there is no new response vectors. If countGreedy = 0,
    % there is no reuse of part 1.
    nVecNew = 0;
else
    % number of nre response vectors.
    nVecNew = obj.no.phy * obj.no.rbAdd * obj.no.t_step;
end

% for hhat, responses need to be chosen based on enrich or refine.
uStorehhat = obj.resp.store.all(idxCompute, :);
% for hat, responses are all hat ones,
uStorehat = obj.resp.store.all(1:obj.no.pre.hat, :);

nVecTot = numel(uStorehhat{1, 3});
nVecOld = nVecTot - nVecNew;

%% 1. compute uiTuj for ehat.
uReordhat = cell(1);
uStoreBlkhat = cell(1);
for im = 1:nBlkhat
    % re-order pre-computed displacements.
    for ic = 1:4
        % get index.
        uReordhat{ic, 1} = pmExpoBlkhat{im}(ic, 1);
        % get location in string.
        uReordhat{ic, 2} = num2str(pmExpoBlkhat{im}(ic, 2:3));
        % find matching index.
        locLogi = (uReordhat{ic, 1} == [uStorehat{:, 1}]');
        % re-order stored responses into clockwise sequence.
        uReordhat{ic, 3} = uStorehat{locLogi, 3};
    end
    % compute the 6 combinations of responses. idx is the combination of
    % indices.
    idx = nchoosek(1:4, 2);
    for id = 1:size(idx, 1)
        
        uExtOld = uReordhat{idx(id, 1), 3}(1:nVecOld);
        uExtNew = uReordhat{idx(id, 1), 3}(end - nVecNew + 1:end);
        uExtpOld = uReordhat{idx(id, 2), 3}(1:nVecOld);
        uExtpNew = uReordhat{idx(id, 2), 3}(end - nVecNew + 1:end);
        lu11 = uTuPart(nVecOld, nVecOld, uExtOld, uExtpOld, 'rectangle');
        % part 2: right upper block, full rectangle, unsymmetric (j from 1).
        ru12 = uTuPart(nVecOld, nVecNew, uExtOld, uExtpNew, 'rectangle');
        % part 3: right lower block, right upper triangle, symmetric.
        rd22 = uTuPart(nVecNew, nVecNew, uExtNew, uExtpNew, 'rectangle');
        % part 4: left lower block, rectangle all-zeros.
        ld21 = uTuPart(nVecNew, nVecOld, uExtNew, uExtpOld, 'rectangle');
        % put part 1 2 3 4 together to form a triangular matrix.
        uTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        uTrans = obj.resp.rv.L' * uTrans_ * obj.resp.rv.L;
        uReordhat{idx(id, 1), 2 + idx(id, 2)} = uTrans;
        uReordhat{idx(id, 1), 5 + idx(id, 2)} = uTrans_;
        
    end
    uStoreBlkhat{im} = uReordhat;
end
obj.err.pre.uiTuj.hat = cellfun(@(v) v(:, [1:2 4:9]), uStoreBlkhat, 'un', 0);
%% 2. compute uiTuj for ehhat.

uStoreBlkhhat = cell(1);
for im = 1:nBlkhhat
    % re-order pre-computed displacements.
    uReordhhat = cell(1);
    for ic = 1:4
        % get index.
        uReordhhat{ic, 1} = pmExpoBlkhhat{im}(ic, 1);
        % get location in string.
        uReordhhat{ic, 2} = num2str(pmExpoBlkhhat{im}(ic, 2:3));
        % find matching index.
        locLogi = (uReordhhat{ic, 1} == [uStorehhat{:, 1}]');
        % re-order stored responses into clockwise sequence.
        uReordhhat{ic, 3} = uStorehhat{locLogi, 3};
    end
    % for each block, compute the 6 combinations of responses. 
    % idx is the combination of indices.
    idx = nchoosek(1:4, 2);
    for id = 1:size(idx, 1)
        
        uExtOld = uReordhhat{idx(id, 1), 3}(1:nVecOld);
        uExtNew = uReordhhat{idx(id, 1), 3}(end - nVecNew + 1:end);
        uExtpOld = uReordhhat{idx(id, 2), 3}(1:nVecOld);
        uExtpNew = uReordhhat{idx(id, 2), 3}(end - nVecNew + 1:end);
        lu11 = uTuPart(nVecOld, nVecOld, uExtOld, uExtpOld, 'rectangle');
        % part 2: right upper block, full rectangle, unsymmetric (j from 1).
        ru12 = uTuPart(nVecOld, nVecNew, uExtOld, uExtpNew, 'rectangle');
        % part 3: right lower block, right upper triangle, symmetric.
        rd22 = uTuPart(nVecNew, nVecNew, uExtNew, uExtpNew, 'rectangle');
        % part 4: left lower block, rectangle all-zeros.
        ld21 = uTuPart(nVecNew, nVecOld, uExtNew, uExtpOld, 'rectangle');
        % put part 1 2 3 4 together to form a triangular matrix.
        uTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        uTrans = obj.resp.rv.L' * uTrans_ * obj.resp.rv.L;
        uReordhhat{idx(id, 1), 2 + idx(id, 2)} = uTrans;
        uReordhhat{idx(id, 1), 5 + idx(id, 2)} = uTrans_;
        
    end
    uStoreBlkhhat{im, 1} = uReordhhat;
end

obj.err.pre.uiTuj.hhat = cellfun(@(v) v(:, [1:2 4:9]), uStoreBlkhhat, 'un', 0);

toc
disp('uiTuj ends')
end