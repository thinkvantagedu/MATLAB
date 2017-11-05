%% Create datastore
fileList = 'indexData\indices*.txt'; 
ds = datastore(fileList, 'Delimiter', ',');
varNames = ds.VariableNames(2:end); % first column is dates
ds.SelectedVariableNames = varNames;
nVars = numel(varNames);

%% Read all data (only possible if complete data fits into memory)
T = readall(ds);

%% Compute mean and standard deviation of returns
m = mean( data );
s = std( data );

%% Visualization of means and standard deviations
visualizeMeanStd(m, s, varNames)