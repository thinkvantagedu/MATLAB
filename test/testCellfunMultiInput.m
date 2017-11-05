% %% this script tests the use of cellfun. Use after GSA.
% 
% % case 1: multi inputs.
% a = pmExp.pre.block.add;
% query_x = 1.63;
% query_y = 1.63;
% test = cellfun(@(a) inpolygon(query_x, query_y, a(:,2), a(:,3)), a);
% 
% % case 2: multi outputs.
% 
% a1 = (-5:9)';
% 
% a2 = (-4:10)';
% 
% a3 = (-3:11)';
% 
% a = {a1 a2 a3};
% 
% aresp = cellfun(@(m) reshape(m, 3, 5), a, 'UniformOutput', false);
% 
% [ax, asigma, ay] = cellfun(@svd, aresp, 'UniformOutput', false);
% 

%%

x = cell(3, 1);

x(1:3) = {rand(5)};

y = rand(5);

z = cell(3, 1);

z = cellfun(@(v) v * y, x, 'UniformOutput', false);