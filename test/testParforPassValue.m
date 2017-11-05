function [otpt_pass] = testParforPassValue(detm)

otpt_pass = zeros(10, 10);

parfor i = 1:100
    
    if detm(i) < 0.5
        
        otpt_val = rand(10, 10);
        otpt_pass = otpt_pass + otpt_val;
        
    end
    
end