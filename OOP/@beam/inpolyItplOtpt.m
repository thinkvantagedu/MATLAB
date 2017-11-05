function [obj] = inpolyItplOtpt(obj, type)
% interpolate from coeff for each pm point in each polygon. Use
% lagItplOtptSingle.

switch type
    case 'hat'
        noBlock = obj.no.block.hat;
        pmBlock = obj.pmExpo.block.hat;
        
    case 'hhat'
        noBlock = obj.no.block.hhat;
        pmBlock = obj.pmExpo.block.hhat;
        
    case 'add'
        noBlock = 4;
        pmBlock = obj.pmExpo.block.add;
        
end


for i_block = 1:noBlock
    switch type
        case 'hat'
            obj.coef.block = obj.coef.hat{i_block};
            if inpolygon(obj.pmExpo.iter{1}, obj.pmExpo.iter{2}, ...
                    pmBlock{i_block}(:, 2), ...
                    pmBlock{i_block}(:, 3)) == 1
                
                obj = lagItplOtptSingle(obj, 'hat');
                
            end
            
        case 'hhat'
            obj.coef.block = obj.coef.hhat{i_block};
            if inpolygon(obj.pmExpo.iter{1}, obj.pmExpo.iter{2}, ...
                    pmBlock{i_block}(:, 2), ...
                    pmBlock{i_block}(:, 3)) == 1
                
                obj = lagItplOtptSingle(obj, 'hhat');
                
            end
        case 'add'
            obj.coef.block = obj.coef.add{i_block};
            if inpolygon(obj.pmExpo.iter{1}, obj.pmExpo.iter{2}, ...
                    pmBlock{i_block}(:, 2), ...
                    pmBlock{i_block}(:, 3)) == 1
                
                obj = lagItplOtptSingle(obj, 'hat');
                
            end
    end    
    
end