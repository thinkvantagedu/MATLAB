a = rand(100000, 2);
b = a(99999, :);

tic
c = ismember(a, b, 'rows');
toc

a1 = [0 0; 1 0; 0 1; 1 1];

b1 = [-0.5 0.5];

c1 = inpolygon(b1(1), b1(2), a1(:, 1), a1(:, 2));