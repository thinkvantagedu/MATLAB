function [obj] = refineGrid(obj, i_block)
% use in refineGridLocalwithIdx.
% pm_inpt is 4 by 2 matrix representing 4 corner coordinate (in a column way). 
% pm_comb_otpt is 5 by 2 matrix representing the computed 5 midpoints. 
% This function is able to compute any number of given blocks, not just one
% block. 

% inpt is a matrix, otpt is also a matrix, not suitable for cell. 

pm_inpt = obj.pmExpo.block.hat{i_block}(:, 2:3);
obj.pmExpo.block.hhat = [];

% add rows of pm_inpt in a sequential way.

for i_1 = 1:length(pm_inpt)-1
    
   for j_1 = i_1+1:length(pm_inpt)
       
      obj.pmExpo.block.hhat = [obj.pmExpo.block.hhat; pm_inpt(i_1, :)+pm_inpt(j_1, :)]; 
       
   end
    
end

% determine if there is repeated columns and delete it.

j_cnt = [];

for i_2 = 1:length(obj.pmExpo.block.hhat)-1
    
    for j_2 = i_2+1:length(obj.pmExpo.block.hhat)
        
        if isequal(obj.pmExpo.block.hhat(i_2, :), obj.pmExpo.block.hhat(j_2, :)) == 1
            
            j_cnt = [j_cnt; j_2];
            
        end
        
    end
    
    obj.pmExpo.block.hhat(j_cnt, :) = [];
    
    j_cnt = [];

end

% divide into half.

obj.pmExpo.block.hhat = obj.pmExpo.block.hhat/2;

% determine if there is repeated points with pm_inpt and delete them.

k_int = [];

for i_3 = 1:length(pm_inpt)
    
   for j_3 = 1:length(obj.pmExpo.block.hhat)
       
      if isequal(pm_inpt(i_3, :), obj.pmExpo.block.hhat(j_3, :)) == 1 
       
         k_int = [k_int; j_3]; 
         
      end
      
   end
   
end

obj.pmExpo.block.hhat(k_int, :) = [];

%% assemble inpt and otpt together.
obj.pmExpo.block.hhat = [pm_inpt; obj.pmExpo.block.hhat];

