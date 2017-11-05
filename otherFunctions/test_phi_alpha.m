clear variables; clc;

dda1 = [1 2 3 4]';
da1 = [5 6 7 8]';
a1 = [1 3 5 7]';

dda2 = [2 4 6 8]';
da2 = [1 4 2 5]';
a2 = [4 2 1 7]';


a0 = rand(10, 4);

b = [a0*dda1; a0*da1; a0*a1; a0*dda2; a0*da2; a0*a2];
b0 = zeros(60, 24);

row = 10;
col = 4;

for i = 1:6
    
    
    b0(((i-1)*row+1):i*row, ((i-1)*col+1):i*col) = b0(((i-1)*row+1):i*row, ((i-1)*col+1):i*col)+a0;
    
    
    
end

c = b0*[dda1; da1; a1; dda2; da2; a2];