function golfmatOuter2
% Set velocity and angle ranges
% Velocity range
velocities = linspace(1,10,100);

% Desired angle and preallocation of minDistance
angles = linspace(pi/6,5*pi/12,50);
minDistance = zeros(length(angles),length(velocities));

% Iterate through angles and velocities to hit the ball
parfor iOuter = 1:numel(angles)
    minDistance(iOuter,:) = golfmatOuter2Fun(angles(iOuter),velocities);
end

% Plot the results
plotGolfMat(angles,velocities,minDistance)


function minDistance =  golfmatOuter2Fun(theta0,velocities)

% Define wind direction in x and y directions
vwindx = 4.5;
vwindy = 4.5/2;
vwind = [vwindx; vwindy];

minDistance = zeros(1,numel(velocities));

for iInner = 1:numel(velocities)
    
    v0 = velocities(iInner);
    
    % Solve the ODE to find appropriate output
    vInit = [v0*cos(theta0);v0*sin(theta0)];
    [t, v] = ode45(@(t, vel) golfeq(t, vel, vwind),0:0.1:15, vInit);
    
    % Integrate velocities to get trajectory of the ball
    s = cumtrapz(t,v);
    x = s(:,1);
    y = s(:,2);
    
    % Find the point that comes closest to the hole
    minDistance(iInner) = min(hypot(x,y-10));
end

