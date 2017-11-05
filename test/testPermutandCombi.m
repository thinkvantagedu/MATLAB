clear variables; clc;
%% both z and b find all combinations of elements from a.
a = [1:4; 5:8];
z = bsxfun(@times, a(:), a(:).');
% z = z(:);

b = a(:)*a(:)';

a1 = [1;2];
a2 = [3;4];
a3 = [5;6];
a4 = [7;8];

a0 = {a1 a2; a3 a4}';