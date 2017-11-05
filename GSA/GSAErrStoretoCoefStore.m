function [coef_block_store] = GSAErrStoretoCoefStore(noTotal, no_block, no_pre, ...
    pm_pre_block, err_pre_trans_store)
% calculate Lagrange interpolation coefficients from sample errors. 
coef_block_store = cell(no_block, 1);

for i_block = 1:no_block
    
    err_slct = cell(4, 1);
    pm_pre_block_indx = pm_pre_block{i_block}(:, 1);
    
    for i_coef = 1:no_pre
        
        err_indx = err_pre_trans_store{i_coef, 1};
        
        for j_coef = 1:4
            
            if isequal(err_indx, pm_pre_block_indx(j_coef)) == 1
                
                [otpt] = reConstruct(err_pre_trans_store{i_coef, 2});
                err_slct(j_coef) = {otpt};
                
            end
            
        end
        
    end
    err_slct_temp = zeros(noTotal*4, noTotal);
    
    for k_coef = 1:4
        
        err_slct_temp((k_coef-1)*noTotal+1:k_coef*noTotal, :) = ...
            err_slct_temp((k_coef-1)*noTotal+1:k_coef*noTotal, :) + ...
            err_slct{k_coef};
        
    end
    
    pm_pre_val_block = 10.^pm_pre_block{i_block}(:, 2:3);
    
    [coef_block] = LagInterpolationCoeff...
        (pm_pre_val_block, err_slct_temp);

    coef_block_store(i_block) = {coef_block};
    
end
