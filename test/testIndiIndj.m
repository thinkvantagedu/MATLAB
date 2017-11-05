clear; clc;
demo = zeros(4, 4);
indj = 1;
for l = 1:2
    
    for j = 1:2
        indi = 1;
        
        for k = 1:2
            
            for i = 1:2
                
%                 disp([indi, indj])
                if indi <= indj
                    demo(indi, indj) = 1;
                    
                end
                indi = indi + 1;
                
            end
            
        end
        indj = indj + 1;
    end
end