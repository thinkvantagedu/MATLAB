function U = heateqGpuFilt(nPoints)
% HEATEQCPUFILT Solves the 2D heat equation
%
%    U = HEATEQCPUFILT(nPoints)  returns a matrix U representing the
%    temperature at each row, column location.
%    The function discretizes a 2D square copper (thermal diffusivity =
%    1.13e-4) plate of length L = 1 by using nPoints points and computes the
%    temperature distribution after Tend = 60.
%    Note: the computation time will be proportional to nPoints^3 since
%    it's a 2D grid and a finer grid results in smaller time steps.
%
%    Example: Computation with 100 grid points
%    U = heateqGpuFilt(100);
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

F = [0  1 0 
     1 -4 1 
     0  1 0];
I = [0  0 0 
     0  1 0 
     0  0 0];
h = I+diffusivity*dt/(dWidth^2)*F;

% Perform iterations
for iter = 1:numIter
    U(idxRow,idxCol) = filter2(h,U,'valid');
end
U = gather(U);

function U = initialTempDistrib(nPoints)

% Initialize each point on the grid to be at room temperature
U = 23*ones(nPoints+2,'gpuArray');

% Create a temperature gradient at the boundary
U(1,:) = linspace(23,200,nPoints+2);
U(end,:) = linspace(100,200,nPoints+2);
U(:,1) = linspace(23,200,nPoints+2);
U(:,end) = linspace(100,200,nPoints+2);
