function rayTraceLoops(DIM,N)
% DIM = dimension of the scene as DIM x DIM pixels (input)
% N = number of spheres (input)
%
% Example: rayTraceLoops(256,20) % about 8 s
% Example: rayTraceLoops(512,20) % about 35 s
% Example: rayTraceLoops(1024,20) % more than 2 minutes

if nargin == 0
    DIM = 256;
    N = 20;
end

% Define N random spheres over the scene
SPHERES = generatespheres(DIM,N);

% Preallocate the scene with a DIM x DIM grid of pixels
bitmap = zeros(DIM,DIM,3,'uint8');

for x = 1:DIM
    for y = 1:DIM
        % for every pixel (x,y) compute RGB triple with respect to spheres 
        [r,g,b] = kernel(x,y,DIM,N,SPHERES);
        bitmap(x,y,1) = r;
        bitmap(x,y,2) = g;
        bitmap(x,y,3) = b;
    end
end

image(bitmap);
ax = gca;
ax.PlotBoxAspectRatio = [1 1 1];
title([num2str(DIM) 'x ' num2str(DIM) ' Image with ' num2str(N) ' Spheres'])
