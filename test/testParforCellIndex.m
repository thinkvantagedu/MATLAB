clear variables; clc;

% inpt_1 = [1; 2; 3; 4];
% inpt_2 = [2; 3; 4];
% inpt_3 = [3; 4];

inpt = rand(3, 3); 

otpt = cell(3, 1);

parfor i1 = 1:3
    
    otpt_1 = arrayfun(@(x)(sin(x)), inpt(i1, :));
    
    for i2 = 1:3
        
        otpt_2 = arrayfun(@(x)(3 * x + 1), inpt(:, i2));
        
        for i3 = 1:3
            
            otpt_3 = arrayfun(@(x)(cos(x)), inpt(i1, :));
            
            otpt{i1, i2, i3} = [otpt_1; otpt_2'; otpt_3];

        end
    end
    
    
    
end