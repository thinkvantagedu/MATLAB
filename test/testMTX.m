clear variables; clc;

K = [1 2 0; 2 1 4; 0 4 3];

f_val = [1:5];

f_vec = zeros(3, 5);

for i = 1:5
    
   f_vec(:, i) = f_vec(:, i)+[f_val(i); 0; 0]; 
    
end

U = K\f_vec;