function U = heateqCpuInd(nPoints)
% HEATEQCPUIND Solves the 2D heat equation
%
%    U = HEATEQCPUIND(nPoints)  returns a matrix U representing the
%    temperature at each row, column location.
%    The function discretizes a 2D square copper (thermal diffusivity =
%    1.13e-4) plate of length L = 1 by using nPoints points and computes the
%    temperature distribution after Tend = 60.
%    Note: the computation time will be proportional to nPoints^3 since
%    it's a 2D grid and a finer grid results in smaller time steps.
%
%    Example: Computation with 100 grid points
%    U = heateqCpuInd(100);
%    imagesc(U)

diffusivity = 1.13e-4;              % thermal diffusivity of copper
width = 1;                          % side length of plate

% Calculate the mesh spacing
dWidth = width/nPoints;

% Length and number of time steps
dt = dWidth^2/(4*diffusivity);      % time step that ensures stability
Tend = 60;                          % simulate 1 minute
numIter = round(Tend/dt);  

% Initialize square grid with starting temperatures
U = initialTempDistrib(nPoints);

% Calculate the coordinates for the neighboring grid points
nInnerRows = nPoints; % square plate
nInnerCols = nPoints;
idxRow = 2:(nInnerRows + 1);
idxCol = 2:(nInnerCols + 1);
north = idxRow - 1;
south = idxRow + 1;
west = idxCol - 1;
east = idxCol + 1;

% Perform iterations
for iter = 1:numIter
    U(idxRow,idxCol) = U(idxRow,idxCol) + diffusivity*dt/(dWidth^2) * ...
        (U(north,idxCol) + U(idxRow,west) - 4*U(idxRow,idxCol) + ...
        U(idxRow,east) + U(south,idxCol));	
end

function U = initialTempDistrib(nPoints)

% Initialize each point on the grid to be at room temperature
U = 23*ones(nPoints+2);

% Create a temperature gradient at the boundary
U(1,:) = linspace(23,200,nPoints+2);
U(end,:) = linspace(100,200,nPoints+2);
U(:,1) = linspace(23,200,nPoints+2);
U(:,end) = linspace(100,200,nPoints+2);
