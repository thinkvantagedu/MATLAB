function obj = resptoErrPreCompAllTimeMatrix2(obj, respSVDswitch, rvSVDswitch)
% CHANGE SIGN in this method!
% here the index follows the refind grid sequence, not a
% sequencial sequence.
% this method compute eTe, results in a square full symmetric
% matrix, to be interpolated.
% reason of using eTe is size of eTe is decided by nt * nj *
% nr. At least this is not related to nd. Cannot use anyting
% relate to nd.
if obj.indicator.refine == 0 && obj.indicator.enrich == 1
    % if no refine, compute the newly added basis vectors for all
    % interpolation samples, extract vectors regarding the newly
    % added basis vectors for each interpolation sample.
    nPre = obj.no.pre.hhat;
    nEx = 0;
    nRb = obj.no.rb;
    nAdd = obj.no.rbAdd;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % if refine, compute the newly added interpolation samples for
    % all basis vectors.
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
    % respPmPass has DIM(ni, nf, nt, nr).
    respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, nRb - nAdd + 1:end);
    respCol = reshape(respPmPass, [1, numel(respPmPass)]);
    % change sign here.
    
    if obj.countGreedy == 1 || ...
            obj.indicator.enrich == 0 && obj.indicator.refine == 1
        respCol = [obj.resp.store.fce.hhat(nEx + iPre) ...
            cellfun(@(x) cellfun(@uminus, x, 'un', 0), respCol, 'un', 0)];
        
    elseif obj.indicator.enrich == 1 && obj.indicator.refine == 0
        respCol = cellfun(@(x) ...
            cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
    end
    obj.resp.store.all{nEx + iPre, 3} = [obj.resp.store.all{nEx + iPre, 3} ...
        respCol];
    respAllCol = obj.resp.store.all{nEx + iPre, 3};
    obj.no.totalVec = numel(respAllCol);
    obj.no.oldVec = obj.no.totalVec - obj.no.newVec;
    
    if respSVDswitch == 0
        respAllCol = cell2mat(cellfun(@(v) cell2mat(v), respAllCol, 'un', 0));
        if rvSVDswitch == 0
            respTrans = respAllCol' * respAllCol;
        elseif rvSVDswitch == 1
            respTrans_ = respAllCol * obj.resp.rv.L;
            respTrans = respTrans_' * respTrans_;
        end
    elseif respSVDswitch == 1
        respTrans_ = zeros(numel(respAllCol));
        % tr(uiTuj) = tr(vri*sigi*vliT*vlj*sigj*vrjT).
        for i = 1:obj.no.totalVec
            u1 = respAllCol{i};
            for j = i:obj.no.totalVec
                u2 = respAllCol{j};
                respTrans_(i, j) = ...
                    trace((u2{3}' * u1{3}) * u1{2}' * (u1{1}' * u2{1}) * u2{2});
            end
        end
        % reconstruct the upper triangular matrix back to full.
        if rvSVDswitch == 0
            respTrans = reConstruct(respTrans_);
        elseif rvSVDswitch == 1
            respTrans_ = reConstruct(respTrans_);
            respTrans = obj.resp.rv.L' * respTrans_ * obj.resp.rv.L;
            % full scale eTe also needs to be stored
            % when apply POD on RV.
            obj.err.pre.hhat(nEx + iPre, 5) = {respTrans_};
        end
    end
    obj.err.pre.hhat(nEx + iPre, 3) = {respTrans};
end

obj.err.pre.hat(1:obj.no.pre.hat, 1:3) = obj.err.pre.hhat(1:obj.no.pre.hat, 1:3);
if rvSVDswitch == 1
    obj.err.pre.hat(1:obj.no.pre.hat, 5) = obj.err.pre.hhat(1:obj.no.pre.hat, 5);
end


% calculate 4th and 6th columns (uiTui+1) of ehhat and ehat.
% calculate ehat, if initial or enrich, reCalculate.
if obj.indicator.refine == 0 && obj.indicator.enrich == 1 
    % if initial iteration or enrich, reCalculate
    respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
    obj.uiTujSort1(respStoretoTrans, rvSVDswitch, respSVDswitch);
    obj.err.pre.hat(:, 4) = obj.err.pre.trans(:, 3);
    if rvSVDswitch == 1
        obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 4);
    end
    
elseif obj.indicator.refine == 1 && obj.indicator.enrich == 0
    % if refine, inherit
    obj.err.pre.hat(1:obj.no.pre.hat, :) = ...
        obj.err.pre.hhat(1:obj.no.pre.hat, :);
    
end

% calculate ehhat, if initial or enrich, reCalculate.
% if obj.countGreedy == 1 || ...
%         obj.indicator.refine == 0 && obj.indicator.enrich == 1
    respStoretoTrans = obj.resp.store.all;
    obj.uiTujSort2(respStoretoTrans, rvSVDswitch, respSVDswitch);
    obj.uiTujSort1(respStoretoTrans, rvSVDswitch, respSVDswitch);
    obj.err.pre.hhat(:, 4) = obj.err.pre.trans(:, 3);
    if rvSVDswitch == 1
        obj.err.pre.hhat(:, 6) = obj.err.pre.trans(:, 4);
    end
% elseif obj.indicator.refine == 1 && obj.indicator.enrich == 0
%     % if refine, only calculate the refined part of the domain, inherit the
%     % rest part of the domain.
%     respStoretoTrans = obj.resp.store.all;
    
    
% end

end