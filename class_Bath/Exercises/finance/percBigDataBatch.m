%% Choose profile and number of workers
myProfile  = 'cluster';   % <-- change to your profile!
p = parcluster(myProfile);
numWorkers = min(8,p.NumWorkers-1);

%% Run code in batch
numPaths = 1e8;
job = batch(p,@percentilesBigData,2,{numPaths},'Pool',numWorkers,...
    'AttachedFiles',{'usEconQuart.mat'}); 

%% Gather outputs
wait(job)
outputs = fetchOutputs(job);
prcData = outputs{1};
prc = outputs{2};
delete(job)

%% Plot percentiles
plot(prcData)
xlabel('Time')
ylabel('Price')
title('Percentile curves')
legend(num2str(prc'), 'location', 'NW')
