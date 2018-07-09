clear; clc;

% this script tests how to iteratively add and remove repeated points.
setOtpt = [3 2 4]';

setAdd = randi([1 9], [9, 1]);

ntot = length(unique(setAdd));
nori = length(unique(setOtpt));

count = 1;

for i = 1:(ntot - nori)
    setOtpt = [setOtpt; setAdd(count)];
    countIn = 1;
    while length(setOtpt) ~= length(unique(setOtpt)) % repeat detected.
        
        setOtpt = [setOtpt(1:end - 1); setAdd(count + countIn)];
        
        countIn = countIn + 1;
        
    end
    % check if there is repeated point in setOtpt.
    count = count + countIn;
    
end