% RUNGOLFMAT Runs the golf simulation sequentially on a single system
%
% See also golfmat

%% Set the range for all parameters
angles = linspace(pi/6, pi/2, 9);
velocities = 0.5:0.5:10;

%% Run the simulations
[best_velocities, xtraj, ytraj] = golfmat(angles, velocities);


%% Plot the results
plotgolf(best_velocities, xtraj, ytraj, angles);