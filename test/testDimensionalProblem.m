% this test tries to find a way to deal with any dimensions with for loop.
clear; clc;
% the 1d case.
inpt1d = [1 2 3]';
otpt1d = zeros(3, 1);
for i = 1:3
    % the operation is square root.
    otpt1d(i) = sqrt(inpt1d(i));
end

% the 2d case.
inpt2d = [1 2 3; 4 5 6; 7 8 9]';
otpt2d = zeros(3, 3);
for i = 1:3
    for j = 1:3
        otpt2d(i, j) = sqrt(inpt2d(i, j));
    end
end

% the correct way is reshape the multidimensional matrix into 1d, proceed,
% then reshape back to multidimension. 