%% Create datastore
fileList = 'airlineData\*.csv'; 
ds = datastore(fileList,...
    'SelectedVariableNames',{'Month','DepDelay'});
ds.ReadSize = 15000;

%% Set up parallel mapreduce environment
p = gcp('nocreate');
if isempty(p)
    p = parpool('local');
end
MR = mapreducer(p);

%% Call mapreduce with mapper and reducer functions 
edges = -30:5:120;
mapper = @(data,~,intermKVStore) histDelayMapper(data, intermKVStore, edges);
histDelayMR = mapreduce(ds,mapper,@histDelayReducer,MR);

%% Read results from key-value datastore 
histInfo = readall(histDelayMR);
histInfo = sortrows(histInfo,'Key');

%% Visualize
figure
ax = axes;
centers = (edges(1:end-1) + edges(2:end))/2;
ribbon(centers, cell2mat(histInfo.Value)')
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