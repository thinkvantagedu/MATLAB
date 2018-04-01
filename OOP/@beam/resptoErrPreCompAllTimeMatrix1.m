function obj = resptoErrPreCompAllTimeMatrix1(obj, respSVDswitch, rvSVDswitch)
% CHANGE SIGN in this method!
% here the index follows the refind grid sequence, not a
% sequencial sequence.
% this method compute eTe, results in a square full symmetric
% matrix, to be interpolated.
% reason of using eTe is size of eTe is decided by nt * nj *
% nr. At least this is not related to nd. Cannot use anyting
% relate to nd.
if obj.indicator.enrich == 1 && obj.indicator.refine == 0
    % if no refine, compute the newly added basis vectors for all 
    % interpolation samples, extract vectors regarding the newly added
    % basis vectors for each interpolation sample.
    nPre = obj.no.pre.hhat;
    nEx = 0;
elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
    % if refine, compute the newly added interpolation samples for 
    % all basis vectors.
    nPre = obj.no.itplAdd;
    nEx = obj.no.itplEx;
end

for iPre = 1:nPre
    obj.err.pre.hhat(nEx + iPre, 1) = {nEx + iPre};
    obj.err.pre.hhat(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    obj.resp.store.all(nEx + iPre, 1) = {nEx + iPre};
    obj.resp.store.all(nEx + iPre, 2) = {obj.pmExpo.hhat(nEx + iPre, 2)};
    if obj.indicator.enrich == 1 && obj.indicator.refine == 0
        % respPmPass has DIM(ni, nf, nt, nr). 
        respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, ...
            obj.no.rb - obj.no.phiAdd + 1:end);
    elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
        respPmPass = obj.resp.store.pm.hhat(nEx + iPre, :, :, :);
    end
    if respSVDswitch == 0
        % respCol changes respPmPass from nD to 2D. respCol aligns
        % in the order of (nf, nt, nr), i.e. loop nf first, then nt, nr.
        respCol = sparse(cat(2, respPmPass{:}));
        % change sign here.
        if obj.indicator.enrich == 1 && obj.indicator.refine == 0
            if obj.countGreedy == 1
                respCol = [obj.resp.store.fce.hhat{iPre} -respCol];
            else
                respCol = -respCol;
            end
        elseif obj.indicator.enrich == 0 && obj.indicator.refine == 1
            % if refine, force responses are also refined,
            % therefore add the newly added force response to pm responses.
            respCol = [obj.resp.store.fce.hhat{nEx + iPre}(:) -respCol];
        end
    elseif respSVDswitch == 1
        % reshape multi dim cell to 2d cell array.
        respCol = reshape(respPmPass, [1, numel(respPmPass)]);
        % change sign here.
        if obj.countGreedy == 1
            respCol = [obj.resp.store.fce.hhat(nEx + iPre) ...
                cellfun(@(x) cellfun(@uminus, x, 'un', 0), ...
                respCol, 'un', 0)]';
        else
            respCol = cellfun(@(x) ...
                cellfun(@uminus, x, 'un', 0), respCol, 'un', 0);
            respCol = respCol';
        end
    end
    obj.resp.store.all{nEx + iPre, 3} = ...
        [obj.resp.store.all{nEx + iPre, 3}; respCol];
    respAllCol = obj.resp.store.all{nEx + iPre, 3};
    if respSVDswitch == 0
        if rvSVDswitch == 0
            respTrans = respAllCol' * respAllCol;
        elseif rvSVDswitch == 1
            respTrans_ = respAllCol * obj.resp.rv.L;
            respTrans = respTrans_' * respTrans_;
        end
    elseif respSVDswitch == 1
        respTrans = zeros(numel(respAllCol));
        if rvSVDswitch == 0
            % trace(uiTuj) = trace(vri*sigi*vliT*vlj*sigj*vrjT).
            for i = 1:numel(respAllCol)
                u1 = respAllCol{i};
                for j = i:numel(respAllCol)
                    u2 = respAllCol{j};
                    respTrans(i, j) = ...
                        trace(u1{3} * u1{2}' * u1{1}' * ...
                        u2{1} * u2{2} * u2{3}');
                end
            end
            % reconstruct the upper triangular matrix back to full.
            respTrans = reConstruct(respTrans);
        end
    end
    obj.err.pre.hhat(nEx + iPre, 5) = {respTrans};
end
% compute uiTui+1 and store in the last column of obj.err.pre.hhat.
respStoretoTrans = obj.resp.store.all;
obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hhat(:, end) = obj.err.pre.trans(:, 3);
% the 5th column of obj.err.pre.hat is inherited from the first
% nhat rows of obj.err.pre.hhat. the 6th column is a recalculation
% using uiTui+1.
obj.err.pre.hat(1:obj.no.pre.hat, 1:5) = ...
    obj.err.pre.hhat(1:obj.no.pre.hat, 1:5);
respStoretoTrans = obj.resp.store.all(1:obj.no.pre.hat, :);
obj.uiTujSort(respStoretoTrans, rvSVDswitch, respSVDswitch);
obj.err.pre.hat(:, 6) = obj.err.pre.trans(:, 3);
end