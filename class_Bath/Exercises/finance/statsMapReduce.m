%% Create datastore
fileList = 'indexData\indices*.txt'; 
ds = datastore(fileList, 'Delimiter', ',');
varNames = ds.VariableNames(2:end); % first column is dates
ds.SelectedVariableNames = varNames;
nVars = numel(varNames);

%% Set up parallel mapreduce environment
p = gcp('nocreate');
if isempty(p)
    p = parpool('local');
end
MR = mapreducer(p);
% For debugging purposes, you can work sequentially
% MR = mapreducer(0);

%% Call mapreduce with mapper and reducer functions 
indexStatsMR = mapreduce(ds,@statsMapper,@statsReducer,MR);

%% Read results from key-value datastore 
results = readall(indexStatsMR);

stats = cell2mat(results.Value);
means = stats(:,1);
stds = stats(:,2);

%% Visualize results
visualizeMeanStd(means, stds, results.Key)
