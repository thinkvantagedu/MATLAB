function [mtx_pre_store_hat] = GSAAffDynmcOpratrPre(coeff, MTX, phi)

% pre-assemble B*M*phi by 4 for affine parameterization.

mtx_pre_store_hat = zeros(size(coeff, 1)/size(coeff, 2)*length(MTX), size(phi, 2));

for i_aff = 1:size(coeff, 1)/size(coeff, 2)
    
    mtx_pre_store_hat((i_aff-1)*length(MTX)+1:i_aff*length(MTX), :) = ...
        mtx_pre_store_hat((i_aff-1)*length(MTX)+1:i_aff*length(MTX), :)+...
        coeff((i_aff-1)*length(MTX)+1:i_aff*length(MTX), :)*MTX*phi;
    
end