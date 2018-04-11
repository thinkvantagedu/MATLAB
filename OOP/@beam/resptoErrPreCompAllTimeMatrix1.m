function obj = resptoErrPreCompAllTimeMatrix1(obj, respSVDswitch, rvSVDswitch)
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
    
    respAllCol = obj.resp.store.all{nEx + iPre, 3};
    obj.no.totalVec = numel(respAllCol);
    obj.no.oldVec = obj.no.totalVec - obj.no.newVec;
    
    if respSVDswitch == 0
        respAllCol = cell2mat(cellfun(@(v) cell2mat(v), respAllCol, 'un', 0));
        if rvSVDswitch == 0
            if obj.countGreedy == 1
                respTrans = respAllCol' * respAllCol;
            else
                respOld = respAllCol(:, 1:obj.no.oldVec);
                respNew = respAllCol(:, end - obj.no.newVec + 1:end);
                % respTrans is made of 4 parts.
                % part 1: left upper block, triangular, symmetric, direct use.
                if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                    % if enrich, inherit eTe part 1.
                    lu11 = triu(obj.err.pre.hhat{nEx + iPre, 3});
                elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                    % if refine, re-compute eTe part 1.
                    lu11 = triu(respOld' * respOld);
                end
                % part 2: right upper block, rectangular, unsymmetric.
                ru12 = respOld' * respNew;
                % part 3: right lower block, triangular, symmetric.
                rd22 = triu(respNew' * respNew);
                % part 4: left lower block, rectangular all-zeros.
                ld21 = zeros(size(ru12, 2), size(ru12, 1));
                respTrans = reConstruct(cell2mat({lu11 ru12; ld21 rd22}));
            end
        elseif rvSVDswitch == 1
            % if SVD on pre-responses and POD on RV, there is no need to 
            % obtain respTrans.
            respTrans_ = respAllCol * obj.resp.rv.L;
            respTrans = respTrans_' * respTrans_;
        end
    elseif respSVDswitch == 1
        respTrans_ = zeros(obj.no.totalVec);
        % symmetric when it's not uiTuj, so j starts from i.
        if obj.countGreedy == 1
            % initial iteration needs to be treated individually, since all
            % informations are new.
            for iTr = 1:obj.no.totalVec
                u1 = respAllCol{iTr};
                for jTr = iTr:obj.no.totalVec
                    u2 = respAllCol{jTr};
                    respTrans_(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
            
            
        else
            respOld = respAllCol(1:obj.no.oldVec);
            respNew = respAllCol(end - obj.no.newVec + 1:end);
            % part 1: left upper block, triangle, symmetric.
            if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                % if enrich, inherit eTe part 1.
                if rvSVDswitch == 0
                    lu11 = triu(obj.err.pre.hhat{nEx + iPre, 3});
                elseif rvSVDswitch == 1
                    lu11 = triu(obj.err.pre.hhat{nEx + iPre, 5});
                end
            elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                % if refine, re-compute eTe part 1.
                lu11 = zeros(obj.no.oldVec);
                for iTr = 1:obj.no.oldVec
                    u1 = respOld{iTr};
                    for jTr = iTr:obj.no.oldVec
                        u2 = respOld{jTr};
                        lu11(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                
            end
            % part 2: right upper block, rectangular, unsymmetric (j from 1).
            ru12 = zeros(obj.no.oldVec, obj.no.newVec);
            for iTr = 1:obj.no.oldVec
                u1 = respOld{iTr};
                for jTr = 1:obj.no.newVec
                    u2 = respNew{jTr};
                    ru12(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
            
            % part 3: right lower block, triangle, symmetric.
            rd22 = zeros(obj.no.newVec, obj.no.newVec);
            for iTr = 1:obj.no.newVec
                u1 = respNew{iTr};
                for jTr = iTr:obj.no.newVec
                    u2 = respNew{jTr};
                    rd22(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                        (u1{1}' * u2{1}) * u2{2});
                end
            end
            % part 4: left lower block, rectangular all-zeros.
            ld21 = zeros(size(ru12, 2), size(ru12, 1));
            respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
        end
        if rvSVDswitch == 0
            respTrans = reConstruct(respTrans_);
        elseif rvSVDswitch == 1
            % store full-scale respTrans_ for next iteration.
            obj.err.pre.hhat(nEx + iPre, 5) = {reConstruct(respTrans_)};
            respTrans = obj.resp.rv.L' * ...
                reConstruct(respTrans_) * obj.resp.rv.L;
            
        end
    end
    obj.err.pre.hhat(nEx + iPre, 3) = {respTrans};
end

obj.err.pre.hat(1:obj.no.pre.hat, 1:3) = ...
    obj.err.pre.hhat(1:obj.no.pre.hat, 1:3);

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