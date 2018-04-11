function obj = uiTui(obj, rvSVDswitch, respSVDswitch)
% an IMPORTANT difference from uiTuj: no of calculations relates to no of
% sample points, not no of blocks.
% all lu11, rd22 blocks are symmetric, thus triangulated. Use triu when
% case 1: respSVDswitch == 0, case 2: respSVDswitch == 1 and enrich (inherit).

% countGreedy = 1 <==> enrich = 1 && refine == 0
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % nPre denotes number of newly added interpolation samples,
    nPre = obj.no.pre.hhat;
    % nEx denotes number of  previously existed interpolation samples.
    nEx = 0;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % nPre + nEx = total number fo interpolation samples.
    nPre = obj.no.itplAdd;
    nEx = obj.no.itplEx;
end

if obj.countGreedy == 1
    % initial Greedy there is no new response vectors.
    nNew = 0;
else
    % number of nre response vectors.
    nNew = obj.no.phy * obj.no.rbAdd * obj.no.t_step;
end

for iPre = 1:nPre
    % separate the newly added and old vectors.
    respExt = obj.resp.store.all{nEx + iPre, 3};
    nTot = numel(respExt);
    nOld = nTot - nNew;
    respOld = respExt(1:nOld);
    respNew = respExt(end - nNew + 1:end);
    
    % part 1: left upper block, right upper triangle, symmetric.
    if obj.countGreedy == 1 || obj.indicator.enrich == 0 && ...
            obj.indicator.refine == 1
        % if initial or refine, re-compute eTe part 1.
        lu11 = eTePart(nOld, nOld, respOld, respOld, 'triangle');
    elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
        % if enrich, inherit eTe part 1.
        lu11 = triu(obj.err.pre.hhat{nEx + iPre, 5});
    end
    % part 2: right upper block, full rectangle, unsymmetric (j from 1).
    ru12 = eTePart(nOld, nNew, respOld, respNew, 'rectangle');
    % part 3: right lower block, right upper triangle, symmetric.
    rd22 = eTePart(nNew, nNew, respNew, respNew, 'triangle');
    % part 4: left lower block, rectangle all-zeros.
    ld21 = zeros(size(ru12, 2), size(ru12, 1));
    
    % put part 1 2 3 4 together to form a triangular matrix.
    respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
    % store full-scale respTrans_ for next iteration.
    obj.err.pre.hhat(nEx + iPre, 5) = {reConstruct(respTrans_)};
    % project full eTe.
    respTrans = obj.resp.rv.L' * reConstruct(respTrans_) * obj.resp.rv.L;
    obj.err.pre.hhat(nEx + iPre, 3) = {respTrans};
    
end

obj.no.newVec = nNew;
obj.no.totalVec = nTot;
obj.no.oldVec = nOld;

% uiTui of ehat is completely inherited from uiTui of ehhat.
obj.err.pre.hat(1:obj.no.pre.hat, [1:3 5]) = obj.err.pre.hhat...
    (1:obj.no.pre.hat, [1:3 5]);


respStoretoTrans = obj.resp.store.all;
obj.uiTujSort1(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hhat(:, 4) = obj.err.pre.trans(:, 3);
if rvSVDswitch == 1
    obj.err.pre.hhat(:, 6) = obj.err.pre.trans(:, 4);
end

respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
obj.uiTujSort1(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hat(:, 4) = obj.err.pre.trans(:, 3);
if rvSVDswitch == 1
    obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 4);
end

end