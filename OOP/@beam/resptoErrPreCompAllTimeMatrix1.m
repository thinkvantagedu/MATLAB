function obj = resptoErrPreCompAllTimeMatrix1(obj, respSVDswitch, rvSVDswitch)
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    nPre = obj.no.pre.hhat;
    nEx = 0;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    nPre = obj.no.itplAdd;
    nEx = obj.no.itplEx;
end

for iPre = 1:nPre
    obj.err.pre.hhat(nEx + iPre, 1) = {nEx + iPre};
    obj.err.pre.hhat(nEx + iPre, 2) = ...
        {obj.pmExpo.hhat(nEx + iPre, 2)};
    obj.resp.store.all(nEx + iPre, 1) = {nEx + iPre};
    obj.resp.store.all(nEx + iPre, 2) = ...
        {obj.pmExpo.hhat(nEx + iPre, 2)};
    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
        respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, ...
            obj.no.rb - obj.no.phiAdd + 1:end);
    elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
        respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, :);
    end
    %     if respSVDswitch == 0
    respCol = sparse(cat(2, respPmPass{:}));
    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
        if obj.countGreedy == 1
            respCol = [obj.resp.store.fce.hhat{iPre} -respCol];
        else
            respCol = -respCol;
        end
    elseif obj.indicator.enrich == 0 && ...
            obj.indicator.refine == 1
        respCol = [obj.resp.store.fce.hhat{nEx + iPre}(:) ...
            -respCol];
    end
    %     elseif respSVDswitch == 1
    %         respCol = reshape(respPmPass, [1, numel(respPmPass)]);
    %         if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    %             if obj.countGreedy == 1
    %                 respCol = [obj.resp.store.fce.hhat(nEx + iPre) ...
    %                     cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
    %                     respCol, 'un', 0)]';
    %             else
    %                 respCol = cellfun(@(x) ...
    %                     cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
    %                 respCol = respCol';
    %             end
    %         elseif obj.indicator.enrich == 0 && ...
    %                 obj.indicator.refine == 1
    %             respCol = [obj.resp.store.fce.hhat(nEx + iPre) ...
    %                 cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
    %                 respCol, 'un', 0)]';
    %         end
    
    %     end
    obj.resp.store.all{nEx + iPre, 3} = ...
        [obj.resp.store.all{nEx + iPre, 3} respCol];
    respAllCol = obj.resp.store.all{nEx + iPre, 3};
    %     if respSVDswitch == 0
    %         if rvSVDswitch == 0
    respTrans = respAllCol' * respAllCol;
    %         elseif rvSVDswitch == 1
    %             respTrans_ = respAllCol * obj.resp.rv.L;
    %             respTrans = respTrans_' * respTrans_;
    %         end
    %     elseif respSVDswitch == 1
    %         respTrans_ = zeros(numel(respAllCol));
    %         for i = 1:numel(respAllCol)
    %             u1 = respAllCol{i};
    %             for j = i:numel(respAllCol)
    %                 u2 = respAllCol{j};
    %                 respTrans_(i, j) = ...
    %                     trace((u2{3}' * u1{3}) * u1{2}' * ...
    %                     (u1{1}' * u2{1}) * u2{2});
    %             end
    %         end
    %         if rvSVDswitch == 0
    %             respTrans = reConstruct(respTrans_);
    %         elseif rvSVDswitch == 1
    %             respTrans_ = reConstruct(respTrans_);
    %             respTrans = obj.resp.rv.L' * respTrans_ * obj.resp.rv.L;
    %         end
    %     end
    obj.err.pre.hhat(nEx + iPre, 5) = {respTrans};
end
respStoretoTrans = obj.resp.store.all;

obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hhat(:, end) = obj.err.pre.trans(:, 3);
obj.err.pre.hat(1:obj.no.pre.hat, 1:5) = ...
    obj.err.pre.hhat(1:obj.no.pre.hat, 1:5);
respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 3);
end