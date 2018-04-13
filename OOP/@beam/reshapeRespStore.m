function obj = reshapeRespStore(obj)
% all lu11, rd22 blocks are symmetric, thus triangulated. Use triu when
% case 1: respSVDswitch == 0, case 2: respSVDswitch == 1 and enrich (inherit).
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    nPre = obj.no.pre.hhat;
    nEx = 0;
    nRb = obj.no.rb;
    nAdd = obj.no.rbAdd;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    nPre = obj.no.itplAdd;
    nEx = obj.no.itplEx;
    nRb = 0;
    nAdd = 0;
end
obj.no.newVec = obj.no.phy * obj.no.rbAdd * obj.no.t_step;

for iPre = 1:nPre
    % define index and pm values for pre-computed eTe and stored responses.
    obj.err.pre.hhat(nEx + iPre, 1) = {nEx + iPre};
    obj.err.pre.hhat(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    obj.resp.store.all(nEx + iPre, 1) = {nEx + iPre};
    obj.resp.store.all(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    % pass needed responses in to be processed.
    respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, nRb - nAdd + 1:end);
    respCol = reshape(respPmPass, [1, numel(respPmPass)]);
    % if enrich + initial iteration, force resp combines ordinary resp;
    % elseif enrich, ordinary resp only; elseif refine, force resp combines
    % ordinary resp. 
    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
        if obj.countGreedy == 1
            respCol = [obj.resp.store.fce.hhat(iPre) ...
                cellfun(@(x) cellfun(@uminus, x, 'un', 0), respCol, 'un', 0)];
        else
            respCol = cellfun(@(x) ...
                cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
        end
    elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
        respCol = [obj.resp.store.fce.hhat(nEx + iPre) ...
            cellfun(@(x) cellfun(@uminus, x, 'un', 0), respCol, 'un', 0)];
    end
    
    obj.resp.store.all{nEx + iPre, 3} = ...
        [obj.resp.store.all{nEx + iPre, 3} respCol];
    
end

end