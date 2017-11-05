function [bestPercentMatch, matchStartIndex] = genematchPar(searchSeq,numParts)
% GENEMATCHPARALLEL splits the data so that GENEMATCH can run in
% parallel on the given searchSeq string to find the best match from the
% gene.txt file.
%
%   [bestPercentMatch, matchStartIndex] = geneMatchParallel(searchSeq)
%   Locates the closest match for searchSeq in a DNA sequence existing in
%   the text file.  Returns the percentage of the sequence that matches as 
%   well as the index for the start of the match in the DNA sequence.
%   Optional arguments allow for a segment of the DNA sequence between
%   startIndex and endIndex to be searched.
% 
%   Example:
%       p = gcp;
%       [bpm,msi] = geneMatchParallel('gattaca',p.NumWorkers);
%

numBases = 7048095;

% Call the splitDataset function to obtain the start and end values
[startValues,endValues] = splitDataset(numBases,numParts);

% Add border handling
offsetLeft = floor(length(searchSeq)/2);
if mod(length(searchSeq),2) == 0
    offsetRight = offsetLeft - 1;
else
    offsetRight = offsetLeft;
end
    
startValues(2:end) = startValues(2:end) - offsetLeft;
endValues(1:end-1) = endValues(1:end-1) + offsetRight;

% Run on different workers
parfor idx = 1:numParts
    [bestPercentMatch(idx),matchStartIndex(idx)] = genematch(searchSeq,startValues(idx),endValues(idx));
end

[bestPercentMatch,iNum] = max(bestPercentMatch);
matchStartIndex = matchStartIndex(iNum);


function [startValues,endValues] = splitDataset(numTotalElements,numParts)

% Divide up the total elements amongst the parts
numPerPart = repmat(floor(numTotalElements/numParts),1,numParts);
leftover = rem(numTotalElements,numParts);
numPerPart(1:leftover) = numPerPart(1:leftover) + 1;

% Determine the start end end values for the vector
endValues = cumsum(numPerPart);
startValues = [1 endValues(1:end-1)+1];
