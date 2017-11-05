%% Create datastore
fileList = 'indexData\indices*.txt'; 
ds = datastore(fileList, 'Delimiter', ',');
varNames = ds.VariableNames(2:end); % first column is dates
ds.SelectedVariableNames = varNames;
nVars = numel(varNames);

%% Start local pool (if not open)
p = gcp('nocreate');
if isempty(p)
    p = parpool('local');
end

%% How many partitions are possible?
N = numpartitions(ds,p) %#ok

%% Determine sums and sums of squares by partitioning
% Iterate through each partition and assign the row of sums and sums of 
% squares to the output, and the number of observations to an element
parfor k = 1:N
    [sums(k,:), summedSquares(k,:), numObs(k)] = calcStats(ds,N,k);
end

%% Determine means and standard deviations
% $s_{N-1} = \sqrt{ \left( \frac{1}{N} \sum_{i=1}^N x_i^2 \right) - 
% \left( \frac{1}{N} \sum_{i=1}^N x_i \right)^2 } * \sqrt{ \frac{N}{N-1} }$
totalNumObs = sum(numObs);
means = sum(sums) / totalNumObs;
stds = sqrt(sum(summedSquares) / totalNumObs - means.^2) * ...
       sqrt(totalNumObs/(totalNumObs-1));

%% Visualize results 
visualizeMeanStd(means, stds, varNames)