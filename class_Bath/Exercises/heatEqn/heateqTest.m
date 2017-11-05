%% Heat equation simulation: processing test script
%
% Compare four versions:
% * CPU, using indexing
% * CPU, using filter2
% * GPU, using indexing
% * GPU, using filter2

% grid size
gridsize = 100:100:400;
N = length(gridsize);

% Preallocation
t = zeros(N,4);

gpu = gpuDevice;
for n = 1:N
    disp(['Running simulation with gridsize ' num2str(gridsize(n))])
    tic; U1 = heateqCpuInd(gridsize(n)); t(n,1) = toc;
    tic; U2 = heateqGpuInd(gridsize(n)); wait(gpu); t(n,2) = toc;
    tic; U3 = heateqCpuFilt(gridsize(n)); t(n,3) = toc;
    tic; U4 = heateqGpuFilt(gridsize(n)); wait(gpu); t(n,4) = toc;
end

%% Visualization 
semilogy(gridsize, t,'o-')
legend('CPU indexing','GPU indexing', 'CPU filter2', 'GPU filter2', 'location', 'NW')
xlabel('Grid Size')
ylabel('Computational Time')
title('Heat Equation Simulation')
set(gca, 'XTick', gridsize)
xlim([min(gridsize) max(gridsize)])