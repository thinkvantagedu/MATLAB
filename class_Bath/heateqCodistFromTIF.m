function U = heateqCodistFromTIF(fname)
% HEATEQCODISTFROMTIF Solves the 2D heat equation, initializing a
% codistributed array from an image
%
%    U = HEATEQCODISTFROMTIF(fname)  returns a matrix U representing the
%    temperature at each row, column location.
%    The function discretizes a 2D square copper (thermal diffusivity =
%    1.13e-4) plate of length L = 1, reads in the initial temperature 
%    distribution from image fname, and computes the temperature 
%    distribution after Tend = 60.
%
%    Example: 
%    spmd
%    U = heateqCodistFromTIF('Upic.tif');
%    end
%    imagesc(U)

diffusivity = 1.13e-4;              % thermal diffusivity of copper
width = 1;                          % width of plate

% Initialize the grid with starting temperatures
U = initialTempDistrib(fname);

% Determine dimensions (drop side rows and side columns)
[nRows, nCols] = size(U);  
nInnerRows = nRows - 2;
nInnerCols = nCols - 2;

% Calculate the mesh spacing
dWidth = width/nCols;

% Length and number of time steps
dt = dWidth^2/(4*diffusivity);      % time step that ensures stability
Tend = 60;                          % simulate 1 minute
numIter = round(Tend/dt);  

% Calculate the coordinates for the neighboring grid points
idxRow = 2:(nInnerRows + 1);
idxCol = 2:(nInnerCols + 1);
north = idxRow - 1;
south = idxRow + 1;
west = idxCol - 1;
east = idxCol + 1;

% Perform time steps
for iter = 1:numIter
    U(idxRow,idxCol) = U(idxRow, idxCol) + diffusivity * dt/(dWidth^2) * ...
        ( U(north,idxCol) + U(idxRow,west) - 4*U(idxRow,idxCol) + ...
        U(idxRow,east) + U(south,idxCol) );
end

function U = initialTempDistrib(fname)
% Determine size information
info = imfinfo(fname);
n = info.Width; % We assume a square matrix U

% Create appropriate distribution scheme
distScheme = codistributor1d(2,[],[n, n]);

% Identify portions to be loaded on each workers
[firstCol,lastCol] = globalIndices(distScheme,2);

% Load respective parts (variant array)
U = imread(fname, 'PixelRegion',{[1,n],[firstCol,lastCol]});

% Rescale
U = double(U) - 1;

% Convert to codistributed array
U = codistributed.build(U, distScheme);
