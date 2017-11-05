function minDistance = golfsim(velocities,angles)

% Preallocation of minDistance
minDistance = zeros(length(angles),length(velocities));

% Iterate through angles and velocities to hit the ball
parfor k = 1:numel(angles)
    minDistance(k,:) = singleGolfSim(angles(k),velocities);
end


function minDistance =  singleGolfSim(theta0,velocities)

% Define wind direction in x and y directions
vwindx = 4.5;
vwindy = 4.5/2;

minDistance = zeros(1, numel(velocities));

for J = 1:numel(velocities)
    
    v0 = velocities(J);
    
    % Solve the ODE to find appropriate output
    simOut = sim('golfmodel','TimeOut',15,'SrcWorkspace','current');
    output = get(simOut,'yout');
    x = output(:, 1);
    y = output(:, 2);
    
    % Find the point that comes closest to the hole
    minDistance(J) = min(hypot(x, y-10));
    
end
