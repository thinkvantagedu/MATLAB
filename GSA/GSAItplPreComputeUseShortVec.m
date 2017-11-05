function [errValStore] = GSAItplPreComputeUseShortVec(no, resp)
% CT = contain time. Real time, not initial and step-in.
% extract from each interpolation sample point to obtain affined error
% matrices, then assemble themrespPreAsembCol into a (no.pre.hhat*1)
% cell according to number of sample points.

errValStore = cell(no.pre.hhat, 2);
funcNeg = @(x) -x;
for iPre = 1:no.pre.hhat
    
    errValStore(iPre, 1) = {iPre};
    respPreStore = resp.store.all_pm.hhat(iPre, :, :, :);
    
    noSpec = no.rb * no.phy;
    noRespBlk = noSpec * 2 + 1;
    % CT, change sign of each element in respPreTemp. 
    respPreTemp = cellfun(funcNeg, respPreStore, ...
        'UniformOutput', false);
    % reshape respPreTemp in one dimension.
    respPreTemp = reshape(respPreTemp, 1, no.rb * no.phy * 2);
    % CT, add the response matrix from force. 
    respPreStore = [resp.store.fce.hhat(iPre) respPreTemp];
    % release all cell elements, results in a no.dof * (no.rb * no.phy * 2
    % + 1) by no.t matrix.
    respPreLongCol = cell2mat(respPreStore');
    % reshape each column of respPreShortColMat into a cell element. 
    % Nth Cell element contains ALL VECS from Nth TIME STEP!!!
    respPreShortColAsemb = mat2cell(respPreLongCol, ...
        no.dof * noRespBlk, ones(1, no.t_step));
    
    funcInnerReshape = @(x) reshape(x, no.dof, noRespBlk);
    funcInnerVecProduct = @(x, y) x' * y;
    funcVecSelect = @(x) x(:, (noRespBlk - noSpec + 1) : noRespBlk);
    
    % all space vectors from Nth TIME STEP!
    respPreShortColReshape = cellfun(funcInnerReshape, ...
        respPreShortColAsemb, 'UniformOutput', false);
    % select the special time steps. 
    respPreShortColReshapeSpec = cellfun(funcVecSelect, ...
        respPreShortColReshape, 'UniformOutput', false);
    
    errBlkMain = cell(no.t_step - 1);
    
    for iBlk = 1:length(errBlkMain)
        for jBlk = iBlk:length(errBlkMain)
            
            if iBlk == 1 && jBlk == 1
                errBlkCell = cellfun(funcInnerVecProduct, ...
                    respPreShortColReshape, respPreShortColReshape, ...
                    'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {triu(sum(cat(3, errBlkCell{:}), 3))};
                
            elseif iBlk == 1 && jBlk ~= 1
                errBlkTemp1 = respPreShortColReshape(jBlk : end);
                errBlkTemp2 = ...
                    respPreShortColReshapeSpec(1:no.t_step - jBlk + 1);
                errBlkTemp = cellfun(funcInnerVecProduct, ...
                    errBlkTemp1, errBlkTemp2, ...
                    'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {sum(cat(3, errBlkTemp{:}), 3)};
                errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
                
            elseif iBlk ~= 1 && iBlk == jBlk
                errBlkTemp1 = ...
                    respPreShortColReshapeSpec(1:no.t_step - jBlk + 1);
                errBlkTemp = cellfun(funcInnerVecProduct, ...
                    errBlkTemp1, errBlkTemp1, 'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {triu(sum(cat(3, errBlkTemp{:}), 3))};
                
            elseif iBlk ~= 1 && iBlk ~= jBlk
                errBlkTemp1 = respPreShortColReshapeSpec...
                    (jBlk - iBlk + 1:no.t_step - iBlk + 1);
                errBlkTemp2 = ...
                    respPreShortColReshapeSpec(1:no.t_step - jBlk + 1);
                errBlkTemp = cellfun(funcInnerVecProduct, ...
                    errBlkTemp1, errBlkTemp2, 'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {sum(cat(3, errBlkTemp{:}), 3)};
                errBlkMain{jBlk, iBlk} = 1;
                errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
                
            end
        end
    end
    errBlkMain = cell2mat(cellfun(@(x) ...
        cell2mat(x), errBlkMain, 'UniformOutput', 0));
    errValStore(iPre, 2) = {errBlkMain};
    
    
end