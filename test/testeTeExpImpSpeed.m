clear; clc;

e = rand(1000000, 2);

tic 
ete = e' * e;
toc

e1 = e(:, 1);
e2 = e(:, 2);

tic
e11 = e1' * e1;
e12 = e1' * e2;
e21 = e2' * e1;
e22 = e2' * e2;
toc