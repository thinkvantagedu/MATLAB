%% Create input data
searchSeq = repmat('gattaca', 1, 10);

%% Create cluster object
cluster = parcluster('local');

%% Create batch job for genematch
jgm = batch(cluster,@genematch,2,{searchSeq},'AttachedFiles',{'gene.txt'});

%% Determine the number of workers
nw = cluster.NumWorkers;

%% Create a batch job with a pool for genematchPar
numParts = nw-2;    % one worker to run as client
                    % one worker to run the previous batch job
jgmp = batch(cluster,@genematchPar,2,{searchSeq,numParts},...
    'Pool',numParts,'AttachedFiles',{'gene.txt'});

%% Wait and return results for each job
wait(jgm);
results = fetchOutputs(jgm);
bpm = results{1};
msi = results{2};

wait(jgmp);
resultsp = fetchOutputs(jgmp);
bpmp = resultsp{1};
msip = resultsp{2};

% Are results the same?
if isequal(bpm,bpmp) && isequal(msi,msip)
    disp('The results of both jobs are identical.')
else
    warning('The results of the jobs are different.')
end

%% Clean up the jobs
delete(jgm)
delete(jgmp)
