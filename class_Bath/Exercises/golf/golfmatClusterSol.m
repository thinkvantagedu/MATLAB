%% Define parameters
velocities = linspace(1,10,100);
angles = linspace(pi/6,pi/2,50);

%% Connect to cluster
c = parcluster('cluster'); % <-- replace 'cluster' with your cluster profile
N = c.NumWorkers;

%% Submit batch job and wait for it to finish
nw = min(N-1,8);
job = batch(c,@golfmatBatchFcn,1,{velocities,angles},'Pool',nw);

%% Retrieve and process results
wait(job)
results = fetchOutputs(job);
minDistance = results{1};
delete(job)

%% Visualization
plotGolfMat(angles,velocities,minDistance)
