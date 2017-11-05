function rayTraceSteps3(DIM,N)
% DIM = dimension of the scene as DIM x DIM pixels (input)
% N = number of spheres (input)
%
% Example: rayTraceSteps3(256,20) 
% Example: rayTraceSteps3(512,20) 

if nargin == 0
    DIM = 256;
    N = 20;
end

% Define N random spheres over the scene
S = generatespheres(DIM,N);
Sxyz = S.xyz;
Srgb = S.rgb;
Srad = S.radius;

% Preallocate 3-dim RGB matrix for the DIM x DIM scene of pixels
bitmap = zeros(DIM,DIM,3,'uint8','gpuArray');

for x = 1:DIM
    f = @kernelln;
    [r,g,b] = arrayfun(f,gpuArray(1:DIM));
    bitmap(x,:,1) = r;
    bitmap(x,:,2) = g;
    bitmap(x,:,3) = b;
end

function [r,g,b] = kernelln(y)
    % (x,y) = coordinate of a single pixel in the scene
    % S = structure of N random spheres, with fields xyz, radius and rgb 
    %
    % Example: compute RGB triple for pixel (16,16) in a 32x32 grid filled
    % with 20 spheres
    %            S = generatespheres(32, 20);
    %            [r,g,b] = kernel(16,16,32,20,S);

    ox = (x - DIM/2);
    oy = (y - DIM/2);

    r = 0;
    g = 0;
    b = 0;
    maxz = -1e6;

    for idx = 1:N    % for each i-th sphere, call the locale function hit
        %% TODO get rid of colon indexing
        [oz, fscale] = hit(ox, oy, Sxyz(idx,:), Srad(idx));
        if (oz > maxz)
            % for internal pixel, rescale color of the i-th sphere
            r = Srgb(idx,1) * fscale * 255;
            g = Srgb(idx,2) * fscale * 255;
            b = Srgb(idx,3) * fscale * 255;
            maxz = oz;
        end
    end
end

image(bitmap);
ax = gca;
ax.PlotBoxAspectRatio = [1 1 1];
title([num2str(DIM) 'x ' num2str(DIM) ' Image with ' num2str(N) ' Spheres'])
end

function [oz, ratio] = hit(ox,oy,xyz,radius)
% Compute distance between pixel (ox,oy) and center xyz of the sphere
dx = ox - xyz(1);
dy = oy - xyz(2);

% Check if the pixel is internal to the projection of the sphere
if (dx*dx + dy*dy < radius*radius)
    dz = sqrt(radius*radius - dx*dx - dy*dy);
    oz = dz + xyz(3);
    ratio = dz / radius;
else
    oz = -1e6;
    ratio = 0;
end
end
