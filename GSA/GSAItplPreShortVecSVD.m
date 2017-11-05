function [errValStore] = GSAItplPreShortVecSVD...
    (noRrb, noRb, noPhy, noPre, noDof, noT, respAllPmStore, respFceStore)
% CT = contain time.
% extract from each interpolation sample point to obtain affined error
% matrices, then assemble themrespPreAsembCol into a (noPre*1)
% cell according to number of sample points.



errValStore = cell(noPre, 2);
funcNeg = @(x) -x;

for iPre = 1:noPre
    
    errValStore(iPre, 1) = {iPre};
    respPreStore = respAllPmStore(iPre, :, :, :);
    respPreRVec = cellfun(@(x)x{1, 2} * x{1, 3}, respPreStore, ...
        'UniformOutput', false);
    noSpec = noRb * noPhy;
    noRespBlk = noSpec * 2 + 1;
    
    % change sign of each element in respPreTemp.
    respPreTemp = cellfun(funcNeg, respPreRVec, ...
        'UniformOutput', false);
    
    % reshape respPreTemp in one dimension.
    respPreTemp = reshape(respPreTemp, 1, noRb * noPhy * 2);
    
    % add the response matrix from force. 
    respFceRVec = cellfun(@(x)x{1, 2} * x{1, 3}, respFceStore, ...
        'UniformOutput', false);
    respPreStore = [respFceRVec(iPre) respPreTemp];
    % release all cell elements, results in a no.dof * (no.rb * no.phy * 2
    % + 1) by no.t matrix.
    respPreShortColMat = cell2mat(respPreStore');
    
    % reshape each column of respPreShortColMat into a cell element. 
    % Nth Cell element contains ALL VECS from Nth TIME STEP!!!
    respPreShortColAsemb = mat2cell(respPreShortColMat, ...
        noRrb * noRespBlk, ones(1, noT));
    
    funcInnerReshape = @(x) reshape(x, noRrb, noRespBlk);
    funcInnerVecProduct = @(x, y) x' * y;
    funcVecSelect = @(x) x(:, (noRespBlk - noSpec + 1) : noRespBlk);
    % all space vectors from Nth TIME STEP!
    respPreShortColReshape = cellfun(funcInnerReshape, ...
        respPreShortColAsemb, 'UniformOutput', false);
    % select the step-in time steps. 
    respPreShortColReshapeSpec = cellfun(funcVecSelect, ...
        respPreShortColReshape, 'UniformOutput', false);
    
    errBlkMain = cell(noT - 1);
    
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
                    respPreShortColReshapeSpec(1:noT - jBlk + 1);
                errBlkTemp = cellfun(funcInnerVecProduct, ...
                    errBlkTemp1, errBlkTemp2, ...
                    'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {sum(cat(3, errBlkTemp{:}), 3)};
                errBlkMain{jBlk, iBlk} = ...
                    {zeros(size(errBlkMain{iBlk, jBlk}{:}'))};
                
            elseif iBlk ~= 1 && iBlk == jBlk
                errBlkTemp1 = ...
                    respPreShortColReshapeSpec(1:noT - jBlk + 1);
                errBlkTemp = cellfun(funcInnerVecProduct, ...
                    errBlkTemp1, errBlkTemp1, 'UniformOutput', false);
                errBlkMain{iBlk, jBlk} = ...
                    {triu(sum(cat(3, errBlkTemp{:}), 3))};
                
            elseif iBlk ~= 1 && iBlk ~= jBlk
                errBlkTemp1 = respPreShortColReshapeSpec...
                    (jBlk - iBlk + 1:noT - iBlk + 1);
                errBlkTemp2 = ...
                    respPreShortColReshapeSpec(1:noT - jBlk + 1);
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