%% Connect to cluster
p = parcluster('cluster');      % <-- change to your profile!
N = p.NumWorkers;
numWorkers = min(8,N-1);

%% Run code in batch
numPaths = 1e8;
job = batch(p,@gdpParVecNoPlot,3,{numPaths},'Pool',numWorkers,...
    'AttachedFiles', {'usEconQuart.mat'});  

%% Gather results
wait(job)
outputs = fetchOutputs(job);
delete(job)

%% Process the data
prc = outputs{1}
biny = outputs{2};
binx = outputs{3};
binx = (binx(1:end-1) + binx(2:end))/2; % convert bin edges to centers
bar(binx,biny)
title(['Final prices of ' num2str(numPaths) ' simulations'])
