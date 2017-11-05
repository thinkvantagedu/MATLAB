%% Velocity range
velocities = 0.5:0.01:10;

%% Define wind direction in x and y directions
vwindx = 4.5;
vwindy = 4.5/2;
vwind = [vwindx; vwindy];

%% Desired angle and preallocation of minDistance
theta0 = pi/6;
minDistance = zeros(1,length(velocities));

%% Iterate through angles to hit the ball
parfor k = 1:numel(velocities)
    v0 = velocities(k);

    % Solve the ODE to find appropriate output
    vInit = [v0*cos(theta0);v0*sin(theta0)];
    [t, v] = ode45(@(t, vel) golfeq(t, vel, vwind),0:0.1:15, vInit);
    
    % Integrate velocities to get trajectory of the ball
    s = cumtrapz(t,v);
    x = s(:,1);
    y = s(:,2);
    
    % Find the point that comes closest to the hole
    minDistance(k) = min(hypot(x,y-10));
end

%% Plot the results
plot(velocities, minDistance)
xlabel('Velocity')
ylabel('Distance to Hole')
[miniMinimum,idx] = min(minDistance);
bestVelocity = velocities(idx);
title(['Closest distance: ',num2str(miniMinimum),...
    ' with initial velocity of ',num2str(bestVelocity)])
