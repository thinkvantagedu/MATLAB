%% Desired angles and preallocations
angles = linspace(pi/6,5*pi/12,25);
minDistance = zeros(size(angles));
bestVelocities = zeros(size(angles));

%% Iterate through angles and velocities to hit the ball
vinit = 5;
for k = 1:numel(angles)
    obj = @(v0) golfObjective(v0,angles(k));
    optimopts = optimoptions('fmincon','Display','off',...
        'FinDiffRelStep',1e-3,'TolX',1e-6,'TolFun',1e-6);
    [bestVelocities(k),minDistance(k),flag] = fmincon(obj,vinit,...
            [],[],[],[],1,10,[],optimopts);
    % Use best velocity as starting guess for next angle
    vinit = bestVelocities(k);
    if flag <= 0
        disp(['There was a problem with angle ' num2str(angles(k))])
    end
end

%% Plot the results
plot(angles*180/pi,bestVelocities,'.-')
xlabel('Angle')
ylabel('Optimal Velocity')
