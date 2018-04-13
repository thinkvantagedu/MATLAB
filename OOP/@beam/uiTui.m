function obj = uiTui(obj)
% an IMPORTANT difference from uiTuj: no of calculations relates to no of
% sample points, not no of blocks.
% all lu11, rd22 blocks are symmetric, thus triangulated. Use triu when
% case 1: respSVDswitch == 0, case 2: respSVDswitch == 1 and enrich (inherit).

% countGreedy = 1 <==> enrich = 1 && refine == 0
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % nPre denotes number of newly added interpolation samples,
    nPointPre = obj.no.pre.hhat;
    % nEx denotes number of  previously existed interpolation samples.
    nPointEx = 0;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % nPre + nEx = total number fo interpolation samples.
    nPointPre = obj.no.itplAdd;
    nPointEx = obj.no.itplEx;
end

if obj.countGreedy == 1
    % initial Greedy there is no new response vectors.
    nVecNew = 0;
else
    % number of nre response vectors.
    nVecNew = obj.no.phy * obj.no.rbAdd * obj.no.t_step;
end

for iPre = 1:nPointPre
    % separate the newly added and old vectors.
    respExt = obj.resp.store.all{nPointEx + iPre, 3};
    nVecTot = numel(respExt);
    nVecOld = nVecTot - nVecNew;
    respOld = respExt(1:nVecOld);
    respNew = respExt(end - nVecNew + 1:end);
    
    % part 1: left upper block, right upper triangle, symmetric.
    if obj.countGreedy == 1 || obj.indicator.enrich == 0 && ...
            obj.indicator.refine == 1
        % if initial or refine, re-compute eTe part 1.
        lu11 = eTePart(nVecOld, nVecOld, respOld, respOld, 'triangle');
        
    elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
        % if enrich, inherit eTe part 1.
        nTri = sqrt(length(obj.indicator.bool));
        lu11 = vectorIntoUpperTriangle(obj.err.pre.hhat{nPointEx + iPre, 5}, ...
            obj.indicator.bool, nTri);
        
    end
    % part 2: right upper block, full rectangle, unsymmetric (j from 1).
    ru12 = eTePart(nVecOld, nVecNew, respOld, respNew, 'rectangle');
    % part 3: right lower block, right upper triangle, symmetric.
    rd22 = eTePart(nVecNew, nVecNew, respNew, respNew, 'triangle');
    % part 4: left lower block, rectangle all-zeros.
    ld21 = zeros(size(ru12, 2), size(ru12, 1));
    
    % put part 1 2 3 4 together to form a triangular matrix.
    respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
    % store [upper triangle transforms into vector] vecTrans_ for 
    % next iteration. bool is the boolean vector for reTriangularise. 
    [bool, vecTrans_] = upperTriangleIntoVector(respTrans_);
    obj.err.pre.hhat(nPointEx + iPre, 5) = {vecTrans_};
    
    % project full eTe.
    respTrans = obj.resp.rv.L' * reConstruct(respTrans_) * obj.resp.rv.L;
    obj.err.pre.hhat(nPointEx + iPre, 3) = {respTrans};
end

obj.indicator.bool = bool;
obj.no.newVec = nVecNew;
obj.no.totalVec = nVecTot;
obj.no.oldVec = nVecOld;

% uiTui of ehat is completely inherited from uiTui of ehhat.
obj.err.pre.hat(1:obj.no.pre.hat, [1:3 5]) = obj.err.pre.hhat...
    (1:obj.no.pre.hat, [1:3 5]);

end