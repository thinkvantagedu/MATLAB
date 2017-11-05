function plotGolfMat(angles,velocities,minDistance)
% Create a contour plot of the minimum distance to the hole
contourf(angles*180/pi,velocities,minDistance')
xlabel('Angle (°)')
ylabel('Velocity (m/s)')
title('Distance to Hole (m)')
colorbar
