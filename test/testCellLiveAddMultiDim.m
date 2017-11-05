clear; clc;

nr = 1;
a = cell(3, nr, 2);
keyboard
for i = 1:3
    for k = 1:2
      a{i, nr, k} = {nr};
      nr = nr + 1;
    end
end