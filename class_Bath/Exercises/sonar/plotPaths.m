function plotPaths(X)
% PLOTPATHS plots the path or paths of the sonar waves
figure
ax = gca;
hold(ax,'on');
ax.YDir = 'reverse' ;
xlabel(ax,'Length (m)')
ylabel(ax,'Depth (m)')
title('Trajectory of Sonar Wave')

axis(ax,'equal')

if iscell(X)
    for iPath = 1:length(X)
        plot(X{iPath}(1,:),X{iPath}(2,:))
    end
else
    plot(X(1,:),X(2,:))
end
