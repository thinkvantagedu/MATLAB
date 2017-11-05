% function [pm_comb_coord] = GSAadaptivityMidPoint(pm_inpt)

% pm_inpt is 2*4 matrix representing 4 corner coordinate (in a row way).
% pm_comb_otpt is 2*5 matrix representing the computed 5 midpoints. 
clear variables; clc;
% pm_init = [0 0; 50 0; 0 50; 50 50]';

% pm_inpt = [0 0; 50 0; 0 50; 50 50]';

pm_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 50 25; 25 50]';

% pm_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 12.5 0; 0 12.5; 12.5 12.5; 25 12.5; 12.5 25; 50 25; 37.5 0; 37.5 12.5;...
%     50 12.5; 37.5 25; 25 50; 0 37.5; 12.5 37.5; 25 37.5; 12.5 50; 37.5 37.5; 50 37.5; 37.5 50]';

pm_comb_coord = [];

% add columns of pm_inpt in a sequential way.

for i = 1:length(pm_inpt)-1
    
   for j = i+1:length(pm_inpt)
       
      pm_comb_coord = [pm_comb_coord pm_inpt(:, i)+pm_inpt(:, j)]; 
       
   end
    
end

% determine if there is repeated columns and delete it.

j_cnt = [];

for i = 1:length(pm_comb_coord)-1
    
    for j = i+1:length(pm_comb_coord)
        
        if isequal(pm_comb_coord(:, i), pm_comb_coord(:, j)) == 1
            
            j_cnt = [j_cnt; j];
            
        end
        
    end
    
    pm_comb_coord(:, j_cnt) = [];
    
    j_cnt = [];

end

% divide into half.

pm_comb_coord = pm_comb_coord/2;





























