function [coeff_store] = LagInterpolationCoeff(xy, z)
% see function GSAMTXinvCoeffConstruct for use. z does not have  to be
% assembled by square matrices. z is assembled in column blocks.

% Output coeff_store has the same size as z.

% compute coefficient matrix X for Lagrange interpolation AX=B. First
% assemble A, konw B, X = A\B. 

% xy = [1 1; 1 2; 2 1; 2 2];
% z = [1 3 1 2 3 1 4 3; 2 4 3 4 2 4 1 2]';
% z = [2; 2; 2; 2];
% z = [1 3 2 4 1 2 1 7; 2 4 1 3 4 3 5 6]';
% z = [1 2 3 4 5 6 7 8]';
%% find unexpanded A, 

x = xy(:, 1);
y = xy(:, 2);
num = size(xy, 1);
mtx = zeros(num, num);

if num == 3
    func = [x; y; diag(eye(num))];
elseif num == 4
    func = [x.*y; x; y; diag(eye(num))];
elseif num == 6
    func =[x.^2; x.*y; y.^2; x; y; diag(eye(num))];
elseif num == 8
    func = [x.^2.*y; x.*y.^2; x.^2; y.^2; x.*y; x; y; diag(eye(num))];
elseif num == 9
    func = [x.^2.*y.^2; x.^2.*y; x.*y.^2; x.^2; y.^2; x.*y; x; y; diag(eye(num))];
end

for i = 1:num
    mtx(:, i) = func((i*num-num+1):i*num);
end

%% if col=1, X = A\B; col~=1, assemble A, then X = A\B.
row = size(z, 1);
col = size(z, 2);
no_block = length(mtx);
n = row/no_block;
if col==1
      
    coeff_store = mtx\z;
  
elseif col>1
    
    mtx_expa = sparse(row, row);
    for i = 1:size(mtx, 1)
        
        for j = 1:size(mtx, 2)
            
            mtx_expa(n*i-n+1:n*i, n*j-n+1:n*j) = ...
                mtx_expa(n*i-n+1:n*i, n*j-n+1:n*j)+mtx(i, j)*eye(n);
            
        end
        
    end
    
    coeff_store = mtx_expa\z;
    
end