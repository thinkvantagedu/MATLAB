function minDistance = golfmatBatchFcn(velocities,angles)

% Preallocation of minDistance
minDistance = zeros(length(angles),length(velocities));

% Iterate through angles and velocities to hit the ball
parfor k = 1:numel(angles)
    minDistance(k,:) = golfmatOuter2Fun(angles(k), velocities);
end
