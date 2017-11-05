%% Define parameters
velocities = linspace(1,10,100);
angles = linspace(pi/6,pi/2,50);

%% Connect to cluster
c = parcluster('local');
N = c.NumWorkers;

%% Submit batch job and wait for it to finish
job = batch(c,@golfmatBatchFcn,1,{velocities,angles},'Pool',N-1);

%% Retrieve and process results
wait(job, 'finished')
results = fetchOutputs(job);
minDistance = results{1};
delete(job)

%% Visualization
plotGolfMat(angles,velocities,minDistance)
