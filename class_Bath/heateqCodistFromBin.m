function U = heateqCodistFromBin(fname)
% HEATEQCODISTFROMBIN Solves the 2D heat equation, initializing a
% codistributed array from a binary file
%
%    U = HEATEQCODISTFROMBIN(fname)  returns a matrix U representing the
%    temperature at each row, column location.
%    The function discretizes a 2D square copper (thermal diffusivity =
%    1.13e-4) plate of length L = 1, reads in the initial temperature 
%    distribution from binary file fname, and computes the temperature 
%    distribution after Tend = 60.
%
%    Example: 
%    spmd
%    U = heateqCodistFromBin('Ubin.dat');
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
info = dir(fname);
nRows = sqrt(info.bytes/8); % We assume a square matrix U
nCols = nRows;

% Create appropriate distribution scheme
distScheme = codistributor1d(2,[],[nRows, nCols]);

% Identify portions to be loaded on each workers
localColumns = globalIndices(distScheme,2);

% Load respective parts (variant array)
% We skip all columns before (i.e. -1) the column where we want to start
map = memmapfile(fname,'Offset',8*nRows*(localColumns(1)-1),...
    'Format',{'double',[nRows,numel(localColumns)],'U'}, ...
    'Repeat',1);
U = map.Data.U;

% Convert to codistributed array
U = codistributed.build(U,distScheme);
