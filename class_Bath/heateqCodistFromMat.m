function U = heateqCodistFromMat(fname)
% HEATEQCODISTFROMMAT Solves the 2D heat equation, initializing a
% codistributed array from a .mat file
%
%    U = HEATEQCODISTFROMMAT(fname)  returns a matrix U representing the
%    temperature at each row, column location.
%    The function discretizes a 2D square copper (thermal diffusivity =
%    1.13e-4) plate of length L = 1, reads in the initial temperature 
%    distribution from .mat file fname, and computes the temperature 
%    distribution after Tend = 60.
%
%    Example: 
%    spmd
%    U = heateqCodistFromMat('Umat.mat');
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
% Open .mat file
matObj = matfile(fname);

% Determine size of U
dims = size(matObj,'U');

% Create appropriate distribution scheme
distScheme = codistributor1d(2,[],dims);

% Identify portions to be loaded on each workers
localColumns = globalIndices(distScheme,2);

% Load respective parts (variant array)
U = matObj.U(:,localColumns);

% Convert to codistributed array
U = codistributed.build(U,distScheme);
