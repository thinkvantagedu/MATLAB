function [sums, summedSquares, numObs] = calcStats(ds,N,k)
% CALCSTATS operates on the datastore partition to return the sums and
% squared sums for each country, as well as the number of observations
%
% See also: calcStatsPartition
subds = partition(ds,N,k);

sums = 0;
summedSquares = 0;
numObs = 0;

% Read and process data
while hasdata(subds)    
    [subdsSums, subdsSummedSquares, subdsNumObs] = processPrices(subds);
    sums = sums + subdsSums;
    summedSquares = summedSquares + subdsSummedSquares;
    numObs = numObs + subdsNumObs;
end

