function statsReducer(intermKey,intermValIter,outKVStore)
% STATSREDUCER combines the intermediate results, and stores the
% statistics for each country

% Set the initial sums and counts to zero
Sum = 0;
sumSquares = 0;
numObs = 0;

% Use hasnext and getnext in while loop to accumulate keys and values
while hasnext(intermValIter)
    intermValue = getnext(intermValIter);
    Sum = Sum + intermValue(1);
    sumSquares = sumSquares + intermValue(2);
    numObs = numObs + intermValue(3);
end

% Find overall mean and std
outValue(1) = Sum/numObs;
outValue(2) = sqrt(sumSquares / numObs - outValue(1).^2) * ...
       sqrt(numObs/(numObs-1));

% Add results to the output datastore
add(outKVStore,intermKey,outValue);
