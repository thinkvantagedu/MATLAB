function [otpt] = randIntSymMTX(n)

d = round(10*rand(n,1)); % The diagonal values

t = round(triu(bsxfun(@min,d,d.').*rand(n),1)); 
% The upper trianglar random values

otpt = diag(d)+t+t.'; % Put them together in a symmetric matrix