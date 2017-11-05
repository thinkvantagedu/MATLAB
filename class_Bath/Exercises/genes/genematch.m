function [bestPercentMatch, matchStartIndex] = genematch(searchSeq, startIndex, endIndex)
% GENEMATCH Searches for best sequence match in a DNA string
% 
%   [bestPercentMatch, matchStartIndex] = ...
%               genematch(searchSeq, startIndex, endIndex)
%   Locates the closest match for searchSeq in a DNA sequence existing in
%   the text file.  Returns the percentage of the sequence that matches as 
%   well as the index for the start of the match in the DNA sequence.
%   Optional arguments allow for a segment of the DNA sequence between
%   startIndex and endIndex to be searched.
%
%   Example:
%       [bpm, msi] = genematch('gattaca');
%


% Read the sequence
fid = fopen('gene.txt','rt');
geneSeq = fscanf(fid,'%c');
fclose(fid);

% Default the start and end index if values not provided
if nargin < 3
    startIndex = 1;
end

if nargin < 4
    endIndex = length(geneSeq);
end

% Search for the substring
[bestPercentMatch, matchStartIndex] = findsubstr(geneSeq(startIndex:endIndex), searchSeq);

function [bestPercentMatch, matchStartIndex] = findsubstr(baseString, searchString)
% FINDSUBSTR Finds the closest match for search string in larger string.
%
%   [BESTPERCENTMATCH, MATCHSTARTINDEX] = FINDSUBSTR(BASESTRING,
%	SEARCHSTRING) Locates the best match for SEARCHSTRING within
%	BASESTRING, returning the percentage of characters that match and the
%	starting index for the best match within BASESTRING.
%
%   Example:
%       baseString = 'abcdefghijklmnopqrstuvwxyz';
%       [bpm, msi] = findsubstr(baseString, 'abc')
%
%       returns bpm = 1, msi = 1
%
%
%       [bpm, msi] = findsubstr(baseString, 'wayz');
%
%       returns bpm = 0.75, msi = 23;
%       


% Default the match parameters to 0
bestPercentMatch = 0;
matchStartIndex = 0;

for startIndex = 1:(length(baseString) - length(searchString) + 1)
    
    % Extract the current section of the base string
    currentSection = baseString(startIndex:startIndex + length(searchString) - 1);
    
    % Determine the percentage of letters that match
    percentMatch = nnz(currentSection == searchString) / length(searchString);
    
    % If the current match reaches or exceeds the threshold, return
    if percentMatch >= bestPercentMatch
        bestPercentMatch = percentMatch;
        matchStartIndex = startIndex;
    end
    
end
