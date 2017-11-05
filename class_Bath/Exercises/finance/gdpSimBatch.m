%% Make sure the client is in the directory with the MAT file
cd(fileparts(which('usEconQuart.mat')))

%% Connect to cluster
p = parcluster('local');
numWorkers = p.NumWorkers;

%% Run code in batch
numPaths = 1e5;
tic
job = batch(p, @gdpParVec,1,{numPaths},'Pool',numWorkers-1); 
wait(job)
outputs = fetchOutputs(job);
prc = outputs{1}
delete(job)
toc
% Try again with more paths and larger number of workers.

%% Performance evaluation
% Chances are that performance was not what you were hoping for. Why?
%
% For batch jobs with the pool option, the workers first need to be
% started. For short jobs, this may take longer than the job itself. 
% Running in batch on the 'local' profile is typically just done as a
% preparation step for running on a cluster.

%% Retain the histogram
% The histogram is generated on the worker which is not helpful to us.
% Call a modified function that returns the histogram data instead.
job = batch(p,@gdpParVecNoPlot,3,{numPaths},'Pool',numWorkers-1); 
wait(job)
outputs = fetchOutputs(job);
delete(job)

prc = outputs{1}
biny = outputs{2};
binx = outputs{3};
binx = (binx(1:end-1) + binx(2:end))/2; % convert bin edges to centers
bar(binx,biny)
title(['Final prices of ' num2str(numPaths) ' simulations'])
