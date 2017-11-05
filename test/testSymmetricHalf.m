clear; clc;

a = rand(5, 1);

b = rand(5, 1);

c = rand(5, 1);

x = {a b c};

xtx = (cell2mat(x))' * (cell2mat(x));

xtxtest = zeros(3, 3);

for i = 1:3
    for j = i:3
        
        pass = x{i}' * x{j};
        xtxtest(i, j) = xtxtest(i, j) + pass;
        
    end
end

