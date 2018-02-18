clear; clc; clf;
% this script explains the time effect problem with increasing
% upper-triangle sparse matrices.
as = 20;
a = rand(as, as);
tria = triu(a);
% spy(tria, 'k');
% 
% hold on
% add = 5;
% b = rand(as + add, as + add);
% b(1:as, 1:as) = 0;
% trib = triu(b);
% spy(trib, 'r')
% 
% c = rand(as + add * 2, as + add * 2);
% c(1:as + add, 1:as + add) = 0;
% tric = triu(c);
% spy(tric, 'b')
% 
% d = rand(as + add * 5, as + add * 5);
% d(1:as + add * 4, 1:as + add * 4) = 0;
% trid = triu(d);
% spy(trid, 'g')

% set(gca, 'XTickLabel', []);
% set(gca, 'YTickLabel', []);


figure(2)

spy(tria, 'k');

xlabel('')
grid minor