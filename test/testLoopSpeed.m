clear all; clc;

profile on

tic
a = rand(100);
b = zeros(100, 100);
c = zeros(100, 100);
d = zeros(100, 100);

% for i = 1:10
%     
%     b = b+a;
%     
% end
% 
% for i = 1:10
%     
%     c = c+a;
%     
%     
% end
% 
% for i = 1:10
%     
%     d = d+a;
%     
% end

for i = 1:10
    
   b = b+a;
   c = c+a;
   d = d+a;
    
end
toc