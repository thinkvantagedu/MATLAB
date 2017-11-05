function histDelayReducer(intermKey,intermValIter,outKVStore)
% HISTDELAYREDUCER combines the intermediate results, and stores the
% aggregated histogram information for each month

% Set the initial histogram information to zero
histInfo = 0;

% Use hasnext and getnext in while loop to accumulate keys and values
while hasnext(intermValIter)
    intermValues = getnext(intermValIter);
    histInfo = histInfo + intermValues;
end

% Add results to the output datastore
add(outKVStore,intermKey,histInfo);
