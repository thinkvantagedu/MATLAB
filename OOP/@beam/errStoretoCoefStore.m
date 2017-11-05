function obj = errStoretoCoefStore(obj, type)
% calculate Lagrange interpolation coefficients from sample error matrices. 

switch type
    
    case 'hhat'
        
        no_block = obj.no.block.hhat;
        no_pre = obj.no.pre.hhat;
        err_pre_trans_store = obj.err.pre.hhat;
        pm_pre_block = obj.pmExpo.block.hhat;
        
    case 'hat'
        
        no_block = obj.no.block.hat;
        no_pre = obj.no.pre.hat;
        err_pre_trans_store = obj.err.pre.hat;
        pm_pre_block = obj.pmExpo.block.hat;
        
end

coefStore = cell(no_block, 1);

noTotal = obj.no.rb * obj.no.phy * obj.no.t_step + 1;

for i_block = 1:no_block
    
    err_slct = cell(4, 1);
    pm_pre_block_indx = pm_pre_block{i_block}(:, 1);
    
    for i_coef = 1:no_pre
        
        err_indx = err_pre_trans_store{i_coef, 1};
        
        for j_coef = 1:4
            
            if isequal(err_indx, pm_pre_block_indx(j_coef)) == 1
                obj.err.reConstruct = err_pre_trans_store{i_coef, 2};
                [obj] = reConstructfromUpRTri(obj);
                
                err_slct(j_coef) = {obj.err.reConstructOtpt};
                
            end
            
        end
        
    end
    err_slct_temp = sparse(noTotal * 4, noTotal);
    
    for k_coef = 1:4
        
        err_slct_temp((k_coef - 1) * noTotal + 1:k_coef * noTotal, :) = ...
            err_slct_temp((k_coef - 1) * noTotal + 1:k_coef * noTotal, :) + ...
            err_slct{k_coef};
        
    end
    
    pm_pre_val_block = 10 .^ pm_pre_block{i_block}(:, 2:3);
    
    obj.pmVal.lagItplCoeff = pm_pre_val_block;
    obj.err.lagItplCoeff = err_slct_temp;
    
    [obj] = lagItplCoeff(obj);
    
    coefStore(i_block) = {obj.coef.singleBlock};

end

switch type
    
    case 'hhat'
        
        obj.coef.hhat = coefStore;
        obj.coef.add = obj.coef.hhat(end - 3 : end);
    case 'hat'
        
        obj.coef.hat = coefStore;

end

