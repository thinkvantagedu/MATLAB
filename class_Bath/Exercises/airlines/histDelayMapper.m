function histDelayMapper(data,intermKVStore,edges)
% HISTDELAYMAPPER maps the histogram data for each month for a portion of
% the data

% Ignore nans
idx =~isnan(data.DepDelay);

% Unique months are key values
G = data.Month(idx);
intermKey = unique(G);

% Group data by month and generate histogram data
f = @(x) {histcounts(x, edges)};
intermData = splitapply(f, data.DepDelay(idx), G);

% Use addmulti to add keys and values
addmulti(intermKVStore,intermKey,intermData); 
