function [obj] = refineGrid(obj, iBlk)
% use in refineGridLocalwithIdx.
% pmInp is 4 by 2 matrix representing 4 corner coordinate (in a column way).
% This function is able to compute any number of given blocks, not just one
% block.
% all given blocks will be refined, nOtptBlk = 4 * nInptBlk.
% inpt is a matrix, otpt is also a matrix, not suitable for cell.

pmInp = obj.pmExpo.block.hat{iBlk}(:, 2:obj.no.inc + 1);
pmExpoHhat = [];
if obj.no.inc == 1
    pmInpUni = unique(pmInp);
    nPmUni = length(pmInpUni);
    pmCell = cell(nPmUni - 1, 1);
    for i = 1:nPmUni - 1
        
        pmCell(i) = {[pmInpUni(i) pmInpUni(i + 1)]};
        
    end
    pmExpoHhat = cellfun(@(v) sum(v) / 2, pmCell, 'un', 0);
    pmExpoHhat = cell2mat(pmExpoHhat);
elseif obj.no.inc == 2
    % add rows of pmInp in a sequential way.
    
    for i1 = 1:length(pmInp)-1
        
        for j1 = i1+1:length(pmInp)
            
            pmExpoHhat = [pmExpoHhat; pmInp(i1, :) + pmInp(j1, :)];
            
        end
        
    end
    
    % determine if there is repeated columns and delete it.
    
    jCnt = [];
    
    for i2 = 1:length(pmExpoHhat)-1
        
        for j2 = i2+1:length(pmExpoHhat)
            
            if isequal(pmExpoHhat(i2, :), pmExpoHhat(j2, :)) == 1
                
                jCnt = [jCnt; j2];
                
            end
            
        end
        
        pmExpoHhat(jCnt, :) = [];
        
        jCnt = [];
        
    end
    
    % divide into half.
    
    pmExpoHhat = pmExpoHhat / 2;
    
    % determine if there is repeated points with pm_inpt and delete them.
    
    kInt = [];
    
    for i3 = 1:length(pmInp)
        
        for j3 = 1:length(pmExpoHhat)
            
            if isequal(pmInp(i3, :), pmExpoHhat(j3, :)) == 1
                
                kInt = [kInt; j3];
                
            end
            
        end
        
    end
    
    pmExpoHhat(kInt, :) = [];

else
    disp('number of inclusions > 2')
end

% assemble inpt and otpt together.
pmExpoHhat = [pmInp; pmExpoHhat];
obj.pmExpo.block.hhat = pmExpoHhat;