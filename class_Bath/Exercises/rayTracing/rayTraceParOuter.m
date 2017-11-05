function rayTraceParOuter(DIM,N)
% DIM = dimension of the scene as DIM x DIM pixels (input)
% N = number of spheres (input)
%
% Example: rayTraceParOuter(256,20) 
% Example: rayTraceParOuter(512,20) 

if nargin == 0
    DIM = 256; 
    N = 20; 
end

% Define N random spheres over the scene
SPHERES = generatespheres(DIM,N);

% Preallocate the scene with a DIM x DIM grid of pixels
bitmap = zeros(DIM,DIM,3,'uint8');

red = zeros(DIM,DIM,'uint8');
green = zeros(DIM,DIM,'uint8');
blue = zeros(DIM,DIM,'uint8');

parfor x = 1:DIM
    for y = 1:DIM
        % for every pixel (x,y) compute RGB triple with respect to spheres 
        [r,g,b] = kernel(x,y,DIM,N,SPHERES);
        red(x,y) = r;
        green(x,y) = g;
        blue(x,y) = b;
    end
end

bitmap(:,:,1) = red;
bitmap(:,:,2) = green; 
bitmap(:,:,3) = blue;

image(bitmap);
ax = gca;
ax.PlotBoxAspectRatio = [1 1 1];
title([num2str(DIM) 'x ' num2str(DIM) ' Image with ' num2str(N) ' Spheres'])
