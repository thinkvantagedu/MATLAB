function histInfo = calcHist(subds, edges)
% CALCHIST operates on the datastore partition to return the bin heights of
% a histogram for each month
histInfo = 0;

% Read and process data
while hasdata(subds)    
    histInfo = histInfo + processDelays(subds, edges);    
end