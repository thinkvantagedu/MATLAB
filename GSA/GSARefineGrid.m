function [pm_comb_coord] = GSARefineGrid(pm_inpt)

%% pm_inpt is 4 by 2 matrix representing 4 corner coordinate (in a column way). 
% pm_comb_otpt is 5 by 2 matrix representing the computed 5 midpoints. 
% This function is able to compute any number of given blocks, not just one
% block. 

% inpt is a matrix, otpt is also a matrix, not suitable for cell. 

% clear variables; clc;
% pm_inpt = [0 0; 50 0; 0 50; 50 50];

% pm_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 50 25; 25 50];

% pm_inpt = [0 0; 50 0; 0 50; 50 50; 25 0; 0 25; 25 25; 12.5 0; 0 12.5; 12.5 12.5; 25 12.5; 12.5 25; 50 25; 37.5 0; 37.5 12.5;...
%     50 12.5; 37.5 25; 25 50; 0 37.5; 12.5 37.5; 25 37.5; 12.5 50; 37.5 37.5; 50 37.5; 37.5 50];

pm_comb_coord = [];

% add rows of pm_inpt in a sequential way.

for i_1 = 1:length(pm_inpt)-1
    
   for j_1 = i_1+1:length(pm_inpt)
       
      pm_comb_coord = [pm_comb_coord; pm_inpt(i_1, :)+pm_inpt(j_1, :)]; 
       
   end
    
end

% determine if there is repeated columns and delete it.

j_cnt = [];

for i_2 = 1:length(pm_comb_coord)-1
    
    for j_2 = i_2+1:length(pm_comb_coord)
        
        if isequal(pm_comb_coord(i_2, :), pm_comb_coord(j_2, :)) == 1
            
            j_cnt = [j_cnt; j_2];
            
        end
        
    end
    
    pm_comb_coord(j_cnt, :) = [];
    
    j_cnt = [];

end

% divide into half.

pm_comb_coord = pm_comb_coord/2;

% determine if there is repeated points with pm_inpt and delete them.

k_int = [];

for i_3 = 1:length(pm_inpt)
    
   for j_3 = 1:length(pm_comb_coord)
       
      if isequal(pm_inpt(i_3, :), pm_comb_coord(j_3, :)) == 1 
       
         k_int = [k_int; j_3]; 
         
      end
      
   end
   
end

pm_comb_coord(k_int, :) = [];

%% assemble inpt and otpt together.
pm_comb_coord = [pm_inpt; pm_comb_coord];

