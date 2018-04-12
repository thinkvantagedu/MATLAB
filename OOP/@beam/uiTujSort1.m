function obj = uiTujSort1(obj, respStoreInpt, rvSVDswitch, respSVDswitch)
% if enrich, inherit part 1 of eTe, elseif refine, re-compute part 1 of eTe.
% no block is symmetric here! Therefore no triu!
respSort = sortrows(respStoreInpt, 2);
if obj.countGreedy ~= 1
    % if not initial Greedy iteration, select the sorted 4th col of err.pre.
    if size(respStoreInpt, 1) == obj.no.pre.hhat
        eTeImport = sortrows(obj.err.pre.hhat, 2);
    elseif size(respStoreInpt, 1) == obj.no.pre.hat
        eTeImport = sortrows(obj.err.pre.hat, 2);
    end
    if rvSVDswitch == 0
        eTeImport = eTeImport(:, 4);
    elseif rvSVDswitch == 1
        eTeImport = eTeImport(:, 6);
    end
end

respCell_ = cell(size(respSort, 1), 4);
nNew = obj.no.newVec;
nOld = obj.no.oldVec;

for iPre = 1:size(respSort, 1)
    if iPre < size(respSort, 1)
        if respSVDswitch == 0
            respExt = ...
                cell2mat(cellfun(@(v) cell2mat(v), respSort{iPre, 3}, 'un', 0));
            respExtp = ...
                cell2mat(cellfun(@(v) cell2mat(v), respSort{iPre + 1, 3}, ...
                'un', 0));
            if rvSVDswitch == 0
                if obj.countGreedy == 1
                    respTrans = respExt' * respExtp;
                else
                    respExtOld = respExt(:, 1:nOld);
                    respExtNew = respExt(:, end - nNew + 1:end);
                    respExtpOld = respExtp(:, 1:nOld);
                    respExtpNew = respExtp(:, end - nNew + 1:end);
                    % lu11 contains informations from previous Greedy iterations,
                    % needs to be treated individually.
                    % import the sorted old information,
                    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                        lu11 = eTeImport{iPre};
                    elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                        lu11 = respExtOld' * respExtpOld;
                    end
                    
                    % part 2: right upper block, rectangular.
                    ru12 = respExtOld' * respExtpNew;
                    % part 3: right lower block, triangular.
                    rd22 = respExtNew' * respExtpNew;
                    % part 4: left lower block, rectangular.
                    ld21 = respExtNew' * respExtpOld;
                    respTrans = cell2mat({lu11 ru12; ld21 rd22});
                end
            elseif rvSVDswitch == 1
                respTrans_ = obj.resp.rv.L' * respExt';
                respTrans__ = respExtp * obj.resp.rv.L;
                respTrans = respTrans_ * respTrans__;
            end
        elseif respSVDswitch == 1
            respTrans_ = zeros(obj.no.totalVec);
            respExt = respSort{iPre, 3};
            respExtp = respSort{iPre + 1, 3};
            
            if obj.countGreedy == 1
                for iTr = 1:obj.no.totalVec
                    u1 = respExt{iTr};
                    for jTr = 1:obj.no.totalVec
                        u2 = respExtp{jTr};
                        respTrans_(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                
            else
                respExtOld = respExt(1:obj.no.oldVec);
                respExtNew = respExt(end - obj.no.newVec + 1:end);
                respExtpOld = respExtp(1:obj.no.oldVec);
                respExtpNew = respExtp(end - obj.no.newVec + 1:end);
                % part 1: left upper block, square.
                if obj.indicator.enrich == 1 && obj.indicator.refine == 0
                    % if enrich, inherit eTe part 1.
                    lu11 = eTeImport{iPre};
                elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
                    % if refine, re-compute eTe part 1.
                    lu11 = zeros(obj.no.oldVec);
                    for iTr = 1:obj.no.oldVec
                        u1 = respExtOld{iTr};
                        for jTr = 1:obj.no.oldVec
                            u2 = respExtpOld{jTr};
                            lu11(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                                (u1{1}' * u2{1}) * u2{2});
                        end
                    end
                end
                % part 2: right upper block, rectangular.
                ru12 = zeros(obj.no.oldVec, obj.no.newVec);
                for iTr = 1:obj.no.oldVec
                    u1 = respExtOld{iTr};
                    for jTr = 1:obj.no.newVec
                        u2 = respExtpNew{jTr};
                        ru12(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                % part 3: right lower block, square.
                rd22 = zeros(obj.no.newVec, obj.no.newVec);
                for iTr = 1:obj.no.newVec
                    u1 = respExtNew{iTr};
                    for jTr = 1:obj.no.newVec
                        u2 = respExtpNew{jTr};
                        rd22(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                % part 4: left lower block, rectangular.
                ld21 = zeros(obj.no.newVec, obj.no.oldVec);
                for iTr = 1:obj.no.newVec
                    u1 = respExtNew{iTr};
                    for jTr = 1:obj.no.oldVec
                        u2 = respExtpOld{jTr};
                        ld21(iTr, jTr) = trace((u2{3}' * u1{3}) * u1{2}' * ...
                            (u1{1}' * u2{1}) * u2{2});
                    end
                end
                respTrans_ = cell2mat({lu11 ru12; ld21 rd22});
                
            end
            if rvSVDswitch == 0
                respTrans = respTrans_;
            elseif rvSVDswitch == 1
                respTrans = obj.resp.rv.L' * respTrans_ * obj.resp.rv.L;
            end
        end
    elseif iPre == size(respSort, 1)
        respTrans = [];
        respTrans_ = [];
    end
    respCell_(iPre, 1) = {respSort{iPre, 1}};
    respCell_(iPre, 2) = {respSort{iPre, 2}};
    respCell_(iPre, 3) = {respTrans};
    if rvSVDswitch == 1
        respCell_(iPre, 4) = {respTrans_};
    end
end
obj.err.pre.trans = sortrows(respCell_, 1);
end