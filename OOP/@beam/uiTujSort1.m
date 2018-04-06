function obj = uiTujSort1(obj, respStoreInpt, rvSVDswitch, respSVDswitch)
% if enrich, inherit part 1 of eTe, elseif refine, re-compute part 1 of eTe.
% no block is symmetric here! Therefore no triu!
respSort = sortrows(respStoreInpt, 2);
if obj.countGreedy ~= 1
    % if not 1st Greedy iteration, select the sorted 4th col of err.pre.
    if size(respStoreInpt, 1) == obj.no.pre.hhat
        eTeImport = sortrows(obj.err.pre.hhat, 2);
    elseif size(respStoreInpt, 1) == obj.no.pre.hat
        eTeImport = sortrows(obj.err.pre.hat, 2);
    end
    eTeImport = eTeImport(:, 4);
end

respCell_ = cell(size(respSort, 1), 4);
nNew = obj.no.newVec;
nOld = obj.no.oldVec;
for iPre = 1:size(respSort, 1)
    if iPre < size(respSort, 1)
        if respSVDswitch == 0
            if obj.countGreedy == 1
                respTrans = respSort{iPre, 3}' * respSort{iPre + 1, 3};
            else
                respP1old = respSort{iPre, 3}(:, 1:nOld);
                respP1new = respSort{iPre, 3}(:, end - nNew + 1:end);
                respP2old = respSort{iPre + 1, 3}(:, 1:nOld);
                respP2new = respSort{iPre + 1, 3}(:, end - nNew + 1:end);
                % lu11 contains informations from previous Greedy iterations, thus
                % needs to be treated individually.
                % import the sorted old information,
                lu11 = eTeImport{iPre};
                ru12 = respP1old' * respP2new;
                rd22 = respP1new' * respP2new;
                ld21 = respP1new' * respP2old;
                respTrans = cell2mat({lu11 ru12; ld21 rd22});
                %             respTrans = respSort{iPre, 3}' * respSort{iPre + 1, 3};
            end
            %             if rvSVDswitch == 0
            %             elseif rvSVDswitch == 1
            %                 respTransSort = ...
            %                     obj.resp.rv.L' * respSort{iPre, 3}' * ...
            %                     respSort{iPre + 1, 3} * obj.resp.rv.L;
            %             end
        elseif respSVDswitch == 1
            %             respSVD = respSort{iPre, 3};
            %             respSVDp = respSort{iPre + 1, 3};
            %             respTrans = zeros(numel(respSVD));
            %             for iTr = 1:numel(respSVD)
            %                 u1 = respSVD{iTr};
            %                 for jTr = 1:numel(respSVD)
            %                     u2 = respSVDp{jTr};
            %                     respTrans(iTr, jTr) = ...
            %                         trace((u2{3}' * u1{3}) * u1{2}' * ...
            %                         (u1{1}' * u2{1}) * u2{2});
            %                 end
            %             end
            %             if rvSVDswitch == 0
            %                 respTransSort = respTrans;
            %             elseif rvSVDswitch == 1
            %                 respTransSort = obj.resp.rv.L' * ...
            %                     respTrans * obj.resp.rv.L;
            %             end
        end
    elseif iPre == size(respSort, 1)
        respTrans = [];
    end
    respCell_(iPre, 1) = {respSort{iPre, 1}};
    respCell_(iPre, 2) = {respSort{iPre, 2}};
    respCell_(iPre, 3) = {respTrans};
    %     if rvSVDswitch == 1
    %         respCell_(iPre, 4) = {respTrans};
    %     end
end
obj.err.pre.trans = sortrows(respCell_, 1);
end