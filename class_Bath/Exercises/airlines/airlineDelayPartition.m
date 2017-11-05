%% Create datastore
fileList = 'airlineData\*.csv'; 
ds = datastore(fileList,...
    'SelectedVariableNames',{'Month','DepDelay'});

%% Start pool (if not open)
p = gcp('nocreate');
if isempty(p)
    p = parpool('local');
end

%% How many partitions are possible?
N = numpartitions(ds,p) %#ok

%% Iterate through each partition and add histogram information
histInfo = 0;
edges = -30:5:120;
parfor k = 1:N
    subds = partition(ds,N,k);
    histInfo = histInfo + calcHist(subds, edges);
end

%% Visualize results
figure
ax = axes;
centers = (edges(1:end-1) + edges(2:end))/2;
ribbon(centers, histInfo')
ax.XLim = [0.5 12.5];
ax.XTick = 1:12;
ax.XTickLabel = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' ...
    'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};
ax.XTickLabelRotation = -30;
ax.YLim = [-35, 125];
ax.YTick = -30:15:120;
ax.YTickLabelRotation = 30;
xlabel('Month')
ylabel('Delay (min)')