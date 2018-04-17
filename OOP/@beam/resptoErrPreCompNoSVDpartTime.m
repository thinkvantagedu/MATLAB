function obj = resptoErrPreCompNoSVDpartTime(obj)

% extract from each interpolation sample point to obtain affined error
% matrices, then assemble them into a (no.pre.hhat * 1)
% cell according to number of sample points.
% CT = contain time. Real time (no.t_step), not initial and step-in (2).
% only saves upper right triangular matrices.

obj.err.pre.hhat = cell(obj.no.pre.hhat, 2);
% nshift is the number of shifted space vectors, which equals to nrb * nphy,
% and is the last n vectors among all partTime space vectors.
nshift = obj.no.rb * obj.no.phy;
% ntotal is the total number of space vectors stored in the partTime code.
ntotal = nshift * 2 + 1;

funcete = @(x, y) x' * y;
funcVecSelect = @(x) x(:, (ntotal - nshift + 1) : ntotal);
for iPre = 1:obj.no.pre.hhat
    
    obj.err.pre.hhat(iPre, 1) = {iPre};
    % extract space-time matrices, not vectors.
    respPmPass = obj.resp.store.tDiff(iPre, :, :, :);
    
    % CT, change sign of each element in respPreTemp.
    respPreTemp = cellfun(@(v) -v, respPmPass, 'un', 0);
    
    % reshape respPreTemp in one dimension.
    respPreTemp = reshape(respPreTemp, 1, obj.no.rb * obj.no.phy * 2);
    
    % CT, add the response from force.
    respFceTemp = obj.resp.store.fce.hhat{iPre};
    respFceTemp = reshape(respFceTemp, [obj.no.dof, obj.no.t_step]);
    respPreStore = [respFceTemp respPreTemp];
    
    % CT, release all cell elements, results in a no.dof *
    % (obj.no.rb * obj.no.phy * 2 + 1) by no.t matrix.
    respPreLongCol = cell2mat(respPreStore');
    
    % reshape each column of respPreLongCol into a cell element.
    % Nth Cell element contains ALL VECS from Nth TIME STEP!!!
    respPreShortColAsemb = mat2cell(respPreLongCol, ...
        obj.no.dof * ntotal, ones(1, obj.no.t_step));
    % ----------------------------------------------------------------------
    % all space vectors from Nth TIME STEP! Each equals to
    % no.dof by (no.rb * no.phy * 2 + no.fce), total no.t_step matrices.
    % respPreShortColReshape has no.t_step cells.
    respPreShortColReshape = cellfun(@(v) reshape(v, obj.no.dof, ntotal), ...
        respPreShortColAsemb, 'un', 0);
    
    % select the special time steps being shifted.
    respPreShortColReshapeSpec = cellfun(funcVecSelect, ...
        respPreShortColReshape, 'un', 0);
    % ----------------------------------------------------------------------
    errBlkMain = cell(obj.no.t_step - 1);
    
    for iBlk = 1:length(errBlkMain)
        for jBlk = iBlk:length(errBlkMain)
            
            if iBlk == 1 && jBlk == 1
                errBlkCell = cellfun(funcete, ...
                    respPreShortColReshape, respPreShortColReshape, 'un', 0);
                errBlkMain{iBlk, jBlk} = ...
                    {triu(sum(cat(3, errBlkCell{:}), 3))};
                
            elseif iBlk == 1 && jBlk ~= 1
                errBlkTemp1 = respPreShortColReshape(jBlk : end);
                % shift.
                errBlkTemp2 = ...
                    respPreShortColReshapeSpec(1:obj.no.t_step - jBlk + 1);
                
                errBlkTemp = cellfun(funcete, errBlkTemp1, errBlkTemp2, 'un', 0);
                
                errBlkMain{iBlk, jBlk} = ...
                    {sum(cat(3, errBlkTemp{:}), 3)};
                errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
                
            elseif iBlk ~= 1 && iBlk == jBlk
                % shift.
                errBlkTemp1 = ...
                    respPreShortColReshapeSpec(1:obj.no.t_step - jBlk + 1);
                
                errBlkTemp = cellfun(funcete, errBlkTemp1, errBlkTemp1, 'un', 0);
                
                errBlkMain{iBlk, jBlk} = ...
                    {triu(sum(cat(3, errBlkTemp{:}), 3))};
                
            elseif iBlk ~= 1 && iBlk ~= jBlk
                % shift.
                errBlkTemp1 = respPreShortColReshapeSpec...
                    (jBlk - iBlk + 1:obj.no.t_step - iBlk + 1);
                % shift.
                errBlkTemp2 = ...
                    respPreShortColReshapeSpec(1:obj.no.t_step - jBlk + 1);
                
                errBlkTemp = cellfun(funcete, errBlkTemp1, errBlkTemp2, 'un', 0);
                
                errBlkMain{iBlk, jBlk} = ...
                    {sum(cat(3, errBlkTemp{:}), 3)};
                errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
                
            end
        end
    end
    
    errBlkMain1 = cell2mat(cellfun(@(x) cell2mat(x), errBlkMain, 'un', 0));
    obj.err.pre.hhat(iPre, 2) = {errBlkMain1};
    
end

obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);
