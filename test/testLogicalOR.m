clear variables; clc;

a = zeros(5, 5);
gen = 1;

refine = 0.1;

for i = 1:numel(a)
    
    if gen == 1 || refine > 100
        a(i) = 1;
    end
    
    refine = refine * 2;
    gen = gen + 1;
    
end