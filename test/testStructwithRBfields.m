clear variables;
clc;
a = [1:6; 7:12]';
field = cell(1, 2);

for i_rb = 1:2
    
    value = zeros(6, 1);
    field{i_rb} = sprintf('rb%d', i_rb);
    value = value+a(:, i_rb);
    s = struct(field{i_rb}, value);
    
end