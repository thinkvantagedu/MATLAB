function obj = uiTujSort1(obj, respStoreInpt, rvSVDswitch, respSVDswitch)
respSort = sortrows(respStoreInpt, 2);
respCell_ = cell(size(respSort, 1), 4);
nNew = obj.no.newVec;
nOld = obj.no.oldVec;
for iPre = 1:size(respSort, 1)
    if iPre < size(respSort, 1)
        %         if respSVDswitch == 0
        if obj.countGreedy == 1
            respTrans = respSort{iPre, 3}' * respSort{iPre + 1, 3};
        else
            respP1old = respSort{iPre, 3}(:, 1:nOld);
            respP1new = respSort{iPre, 3}(:, end - nNew + 1:end);
            respP2old = respSort{iPre + 1, 3}(:, 1:nOld);
            respP2new = respSort{iPre + 1, 3}(:, end - nNew + 1:end);
            lu11 = respP1old' * respP2old;
            ru12 = respP1old' * respP2new;
            rd22 = respP2new' * respP2new;
            ld21 = respP1new' * respP2old;
            respTrans = cell2mat({lu11 ru12; ld21 rd22});
        end
        %             if rvSVDswitch == 0
        respTransSort = respTrans;
        %             elseif rvSVDswitch == 1
        %                 respTransSort = ...
        %                     obj.resp.rv.L' * respSort{iPre, 3}' * ...
        %                     respSort{iPre + 1, 3} * obj.resp.rv.L;
        %             end
        %         elseif respSVDswitch == 1
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
        %         end
    elseif iPre == size(respSort, 1)
        %         respTrans = [];
        respTransSort = [];
    end
    respCell_(iPre, 1) = {respSort{iPre, 1}};
    respCell_(iPre, 2) = {respSort{iPre, 2}};
    respCell_(iPre, 3) = {respTransSort};
    %     if rvSVDswitch == 1
    %         respCell_(iPre, 4) = {respTrans};
    %     end
end
obj.err.pre.trans = sortrows(respCell_, 1);
keyboard
end