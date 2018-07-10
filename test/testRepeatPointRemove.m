clear; clc;

% this script tests how to iteratively add and remove repeated points.
setOtpt = [2 3 4]';

setAdd = randi([1, 5], [5, 1]);

ntot = length(unique(setAdd));
nori = length(unique(setOtpt));

count = 1;

for i = 1:length(setAdd)
    setOtpt = [setOtpt; setAdd(i)];
    countIn = 1;
    while length(setOtpt) ~= length(unique(setOtpt)) % repeat detected.
        if i + countIn <= length(setAdd)
            setOtpt = [setOtpt(1:end - 1); setAdd(i + countIn)];
        else
            setOtpt = setOtpt(1:end - 1);
        end
        countIn = countIn + 1;
        
    end
    % check if there is repeated point in setOtpt.
    
end



A = [2 3 4] ;
B = randi([1, 9], [9, 1]) ;
%% check for B
[C,ia,ib] = unique(B) ;
if length(C)==length(B)
    fprintf('B has no repeated elements\n') ;
    R = A+C ;
else
    fprintf('B has repeated elements\n') ;
end