% RUNPOPSOL Solution to population dynamics exercise

%% Start the Parallel Command Window (Skip if already running)
parpool(2)

%% Run the distributed version of the code
tic;
cycles = parpopdynamics(5000, [1.5 3.0], 1e-5, 1200, 10000);
toc

%% Plot the results
plot(1.5:1e-5:3, cycles)

%% Close the matlabpool
delete(gcp)
