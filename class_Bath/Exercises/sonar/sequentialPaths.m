%% Inputs
z0 = 5;
theta0(1) = -80;
theta0(2) = 80;
nAnglePaths = 200;

%% Create the vector of initial angles
angle = linspace(theta0(1),theta0(2),nAnglePaths);

%% Preallocate cell array memory for output 
X = cell(1,numel(angle));

%% Iterate through all angles
for iAngle=1:numel(angle)
    theta0 = angle(iAngle);
    X{iAngle} = singlePath(z0,theta0);
end

%% Plot results
plotPaths(X)
