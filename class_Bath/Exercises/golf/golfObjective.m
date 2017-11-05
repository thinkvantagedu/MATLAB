function minDistance = golfObjective(v0,theta0)

% Define wind direction in x and y directions
vwindx = 4.5;
vwindy = 4.5/2;
vwind = [vwindx; vwindy];

% Solve the ODE to find appropriate output
odeopts = odeset('RelTol',1e-9);
vInit = [v0*cos(theta0);v0*sin(theta0)];
[t, v] = ode45(@(t, vel) golfeq(t, vel, vwind),0:0.1:15, vInit, odeopts);

% Integrate velocities to get trajectory of the ball
s = cumtrapz(t,v);
x = s(:,1);
y = s(:,2);

% Find the point that comes closest to the hole
minDistance = min(hypot(x,y-10));
