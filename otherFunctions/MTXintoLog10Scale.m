function [otpt] = MTXintoLog10Scale(inpt)
% inpt can be matrix with any size, otpt gives log10 of inpt elements.
otpt = zeros(size(inpt));

for i = 1:size(inpt, 1)
    
    for j = 1:size(inpt, 2)
        
        otpt(i, j) = otpt(i, j)+log10(inpt(i, j));
        
    end
    
end