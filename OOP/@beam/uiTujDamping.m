function obj = uiTujDamping(obj)
% an IMPORTANT difference from uiTui: no of calculations relates to no of
% blocks, not no of sample points.
disp('uiTuj starts')

tic
pmExpoBlkhat = obj.pmExpo.block.hat;
nBlkhat = obj.no.block.hat;

if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % responses of these indices are needed: all hhat indices.
    idxCompute = obj.pmExpo.hhat(:, 1);
    nBlkComp = obj.no.block.hhat;
    pmExpoBlkhhat = obj.pmExpo.block.hhat;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % responses of these indices are needed: newly added indices.
    idxAdd = cell2mat(obj.pmExpo.block.add);
    idxCompute = unique(idxAdd(:, 1));
    % no of blocks need to be computed.
    nBlkComp = obj.no.block.add + 1;
    pmExpoBlkhhat = obj.pmExpo.block.add;
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
% ehat before ehhat because if refine, ehat is inherited from the previous
% ehhat. If calculate ehat after ehhat, ehat is inherited from the current
% ehhat.

% if initial, compute full for all blocks.
% if refine, inherit part 1 2 3 4 of all blocks from ehhat, no computation.
% if enrich, inherit part 1 from ehat, compute part 2 3 4 for all blocks.

% initial and enrich should be combined, by defining the new vecs and old
% vecs properly. So there is no initial when enrich.

% different from uiTuj, there is no sorting here, use uReord and uStoreBlk
% instead.
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % store matching responses in uStoreBlk.
    uStoreBlkhat = cell(1);
    for iPre = 1:nBlkhat
        uReordhat = cell(1);
        % re-order pre-computed displacements.
        for ic = 1:4
            % get index.
            uReordhat{ic, 1} = pmExpoBlkhat{iPre}(ic, 1);
            % get location in string.
            uReordhat{ic, 2} = num2str(pmExpoBlkhat{iPre}(ic, 2:3));
            % find matching index.
            locLogi = (uReordhat{ic, 1} == [uStorehat{:, 1}]');
            % re-order stored responses into clockwise sequence.
            uReordhat{ic, 3} = uStorehat{locLogi, 3};
        end
        % for the 2d case, the order of the samples isn't clockwise, but
        % pointing downwards. Has to shift here. For uiTui, shift when 
        % interpolate.
        uReordhat = uReordhat([1 2 4 3], :);
        % compute the 6 combinations of responses. idx is the combination of
        % indices.
        subs = nchoosek(1:4, 2);
        for is = 1:size(subs, 1)
            
            uExtOld = uReordhat{subs(is, 1), 3}(1:nVecOld);
            uExtNew = uReordhat{subs(is, 1), 3}(end - nVecNew + 1:end);
            uExtpOld = uReordhat{subs(is, 2), 3}(1:nVecOld);
            uExtpNew = uReordhat{subs(is, 2), 3}(end - nVecNew + 1:end);
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
            uReordhat{subs(is, 1), 2 + subs(is, 2)} = uTrans;
            uReordhat{subs(is, 1), 5 + subs(is, 2)} = uTrans_;
            
        end
        uStoreBlkhat{iPre} = uReordhat;
    end
    obj.err.pre.uiTuj.hat = ...
        cellfun(@(v) v(:, [1:2 4:9]), uStoreBlkhat, 'un', 0);
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % if refine (initial or not), inherit from previous ehhat.
    obj.err.pre.uiTuj.hat = obj.err.pre.uiTuj.hhat;
end
%% 2. compute uiTuj for ehhat.
% if initial, compute full for all blocks.
% if refine, inherit the non-refined blocks from ehhat and compute full for
% refined blocks.
% if enrich, inherit part 1 from ehhat and compute part 2 3 4 for all blocks.
uStoreBlkhhat = cell(1);
for iPre = 1:nBlkComp
    % re-order pre-computed displacements.
    uReordhhat = cell(1);
    for ic = 1:4
        % get index.
        uReordhhat{ic, 1} = pmExpoBlkhhat{iPre}(ic, 1);
        % get location in string.
        uReordhhat{ic, 2} = num2str(pmExpoBlkhhat{iPre}(ic, 2:3));
        % find matching index.
        locLogi = (uReordhhat{ic, 1} == [uStorehhat{:, 1}]');
        % re-order stored responses into clockwise sequence.
        uReordhhat{ic, 3} = uStorehhat{locLogi, 3};
    end
    % for the 2d case, the order of the samples isn't clockwise, but
    % pointing downwards. Has to shift here. For uiTui, shift when interpolate.
    uReordhhat = uReordhhat([1 2 4 3], :);
    % for each block, compute the 6 combinations of responses.
    % idx is the combination of indices.
    subs = nchoosek(1:4, 2);
    for is = 1:size(subs, 1)
        
        uExtOld = uReordhhat{subs(is, 1), 3}(1:nVecOld);
        uExtNew = uReordhhat{subs(is, 1), 3}(end - nVecNew + 1:end);
        uExtpOld = uReordhhat{subs(is, 2), 3}(1:nVecOld);
        uExtpNew = uReordhhat{subs(is, 2), 3}(end - nVecNew + 1:end);
        lu11 = uTuPart(nVecOld, nVecOld, uExtOld, uExtpOld, 'rectangle');
        % part 1: left upper block, unsymmetric.
        if obj.countGreedy == 0 || obj.indicator.enrich == 0 && ...
                obj.indicator.refine == 1
            % if initial or refine, re-compute eTe part 1.
            lu11 = uTuPart(nVecOld, nVecOld, uExtOld, uExtpOld, 'rectangle');
            
        elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
            % if enrich, inherit eTe part 1.
            eTeImporthhat = obj.err.pre.uiTuj.hhat{iPre};
            lu11 = eTeImporthhat{subs(is, 1), 4 + subs(is, 2)};
        end
        % part 2: right upper block, full rectangle, unsymmetric (j from 1).
        ru12 = uTuPart(nVecOld, nVecNew, uExtOld, uExtpNew, 'rectangle');
        % part 3: right lower block, right upper triangle, symmetric.
        rd22 = uTuPart(nVecNew, nVecNew, uExtNew, uExtpNew, 'rectangle');
        % part 4: left lower block, rectangle all-zeros.
        ld21 = uTuPart(nVecNew, nVecOld, uExtNew, uExtpOld, 'rectangle');
        % put part 1 2 3 4 together to form a triangular matrix.
        uTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        uTrans = obj.resp.rv.L' * uTrans_ * obj.resp.rv.L;
        uReordhhat{subs(is, 1), 2 + subs(is, 2)} = uTrans;
        uReordhhat{subs(is, 1), 5 + subs(is, 2)} = uTrans_;
        
    end
    uStoreBlkhhat{iPre, 1} = uReordhhat;
end

if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % if enrich, uiTuj.hhat takes all computed blocks.
    obj.err.pre.uiTuj.hhat = cellfun(@(v) ...
        v(:, [1:2 4:9]), uStoreBlkhhat, 'un', 0);
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % if refine, uiTuj.hhat takes unrefined blocks + 4 computed blocks.
    nRef = obj.no.refBlk;
    refBlks = cellfun(@(v) v(:, [1:2 4:9]), uStoreBlkhhat, 'un', 0);
    % delete the refined block from all blocks.
    unRefBlks = obj.err.pre.uiTuj.hhat;
    unRefBlks(nRef) = [];
    obj.err.pre.uiTuj.hhat = [unRefBlks; refBlks];
    % check: uiTujhhat here is not clockwise, in order to match condition
    % in interpolation, see inpolyItplExpo.
end

toc
disp('uiTuj ends')
end