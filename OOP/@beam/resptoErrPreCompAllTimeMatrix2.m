function obj = resptoErrPreCompAllTimeMatrix2(obj, respSVDswitch, rvSVDswitch)
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
    obj.err.pre.hhat(nEx + iPre, 1) = {nEx + iPre};
    obj.err.pre.hhat(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    obj.resp.store.all(nEx + iPre, 1) = {nEx + iPre};
    obj.resp.store.all(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, nRb - nAdd + 1:end);
    respCol = reshape(respPmPass, [1, numel(respPmPass)]);
    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
        if obj.countGreedy == 1
            respCol = [obj.resp.store.fce.hhat(iPre) ...
                cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
                respCol, 'un', 0)];
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
    respAllCol = obj.resp.store.all{nEx + iPre, 3};
    obj.no.oldVec = size(respAllCol, 2) - obj.no.newVec;
    
    if respSVDswitch == 0
        respAllCol = cell2mat(cellfun(@(v) cell2mat(v), respAllCol, 'un', 0));
        if rvSVDswitch == 0
            if obj.countGreedy == 1
                respTrans = respAllCol' * respAllCol;
            else
                respOld = respAllCol(:, 1:obj.no.oldVec);
                respNew = respAllCol(:, end - obj.no.newVec + 1:end);
                % respTrans is made of 4 parts.
                % part 1: left upper block, triangle, symmetric, direct use.
                if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                    % if enrich, inherit eTe part 1.
                    lu11 = triu(obj.err.pre.hhat{nEx + iPre, 3});
                elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                    % if refine, re-compute eTe part 1.
                    lu11 = respOld' * respOld;
                end
                % part 2: right upper block, rectangular, unsymmetric (j from 1).
                ru12 = respOld' * respNew;
                % part 3: right lower block, triangle, symmetric.
                rd22 = triu(respNew' * respNew);
                % part 4: left lower block, rectangular all-zeros.
                ld21 = zeros(size(ru12, 2), size(ru12, 1));
                respTrans = reConstruct(cell2mat({lu11 ru12; ld21 rd22}));
            end
            
        elseif rvSVDswitch == 1
            respTrans_ = respAllCol * obj.resp.rv.L;
            respTrans = respTrans_' * respTrans_;
        end
    elseif respSVDswitch == 1
        respTrans_ = zeros(numel(respAllCol));
        % symmetric when it's not uiTuj, so j starts from i.
        if obj.countGreedy == 1
            % initial iteration needs to be treated individually, since all
            % informations are new.
            for i = 1:numel(respAllCol)
                u1 = respAllCol{i};
                for j = i:numel(respAllCol)
                    u2 = respAllCol{j};
                    respTrans_(i, j) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
        else
            respOld = respAllCol(1:obj.no.oldVec);
            respNew = respAllCol(end - obj.no.newVec + 1:end);
            % part 1: left upper block, triangle, symmetric, direct use.
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                % if enrich, inherit eTe part 1.
                lu11 = triu(obj.err.pre.hhat{nEx + iPre, 3});
            elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                % if refine, re-compute eTe part 1.
                lu11 = zeros(obj.no.oldVec);
                for i = 1:obj.no.oldVec
                    u1 = respOld{i};
                    for j = 1:obj.no.oldVec
                        u2 = respOld{j};
                        lu11(i, j) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                lu11 = triu(lu11);
            end
            % part 2: right upper block, rectangular, unsymmetric (j from 1).
            ru12 = zeros(obj.no.oldVec, obj.no.newVec);
            for i = 1:obj.no.oldVec
                u1 = respOld{i};
                for j = 1:obj.no.newVec
                    u2 = respNew{j};
                    ru12(i, j) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
            % part 3: right lower block, triangle, symmetric.
            rd22 = zeros(obj.no.newVec, obj.no.newVec);
            for i = 1:obj.no.newVec
                u1 = respNew{i};
                for j = 1:obj.no.newVec
                    u2 = respNew{j};
                    rd22(i, j) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
            rd22 = triu(rd22);
            % part 4: left lower block, rectangular all-zeros.
            ld21 = zeros(size(ru12, 2), size(ru12, 1));
            respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        end
        if rvSVDswitch == 0
            respTrans = reConstruct(respTrans_);
        elseif rvSVDswitch == 1
            respTrans = obj.resp.rv.L' * ...
                reConstruct(respTrans_) * obj.resp.rv.L;
        end
    end
    obj.err.pre.hhat(nEx + iPre, 3) = {respTrans};
end

respStoretoTrans = obj.resp.store.all;
obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hhat(:, 4) = obj.err.pre.trans(:, 3);
if rvSVDswitch == 1
    obj.err.pre.hhat(:, 6) = obj.err.pre.trans(:, 4);
end
obj.err.pre.hat(1:obj.no.pre.hat, 1:3) = ...
    obj.err.pre.hhat(1:obj.no.pre.hat, 1:3);
respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hat(:, 4) = obj.err.pre.trans(:, 3);
if rvSVDswitch == 1
    obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 4);
end
end