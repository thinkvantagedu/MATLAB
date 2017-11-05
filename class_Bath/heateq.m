function U = heateq(k, n, Ts, L, c)
% HEATEQ Solves the 2D heat equation 
%
%    U = HEATEQ(k, n, Ts, L, c)  returns a matrix U representing the 
%    temperature at each row, column location.  The function discretizes a 
%    2D square plate of length L and thermal diffusivity c by using n 
%    points.  The function will perform k iterations using the timestep Ts.
%
%    Example: Solve for the temperature on a 3 m -by- 3 m copper plate 
%    after 40 seconds have elapsed, using 500 time steps of 80 milliseconds
%    each.  The thermal diffusivity of copper is:  1.13e-4 m^2/s
%
%    U = heateq(1e3, 500, 0.08, 3, 1.13e-4);

% Calculate the mesh spacing
ms = L / n;  

% Sanity Check: Ensure time step is small enough for stability
if Ts > (ms^2/2/c)
    error('Selected time step is too large.');
end

% Initialize the grid with starting temperatures
U = initialTempDistrib(n);

% Calculate the coordinates for the neighboring grid points
north   = 1:n;
south   = 3:(n + 2);
current = 2:(n + 1);
east    = 3:(n + 2);
west    = 1:n;

% Perform k iterations
for iter = 1:k    
    U(current, current) = U(current, current) + c * Ts/(ms^2) * (U(north, current) + ...
                          U(south, current) - 4*U(current, current) + ...
                          U(current, east) + U(current, west));	
end

end % heateq

function Uinit = initialTempDistrib(nPoints)

% Initialize the grid at room temperature.
roomTemp = 23;
Uinit = roomTemp * ones(nPoints+2);

% Center and radius of the coffee cup.
gridCenter = round(size(Uinit)/2); % The middle of the grid.
cupRadiusSq = round(size(Uinit, 1)/4).^2; % A quarter of the grid dimension, squared.

% Assume that placing the cup on the grid provides an initial heat
% distribution at the immediate contact points. Placing the cup of
% coffee on the grid defines an initial annulus (ring band) of heat,
% hottest at the immediate contact points and tapering off at the edges of
% the annulus.

% Define the semi-bandwidth of the annulus.
semiBandWidthSq = round(size(Uinit, 1)/10).^2; % 10% of the grid dimension, squared.

% Coffee cup parameters.
nHeatBands = 25;
cupLowerTemp = 50;
cupUpperTemp = 80;
bandTemps = linspace(cupLowerTemp, cupUpperTemp, nHeatBands);
inner = cupRadiusSq - semiBandWidthSq;
outer = cupRadiusSq + semiBandWidthSq;

% Pre-compute squared distances from grid points to the centre of the annulus.
x = 1:nPoints+2;
[X, Y] = meshgrid(x, x);
D = (X - gridCenter(2)).^2 + (Y - gridCenter(1)).^2;

% Initialize the temperature gradient caused by the placement of the cup.
for k = 1:nHeatBands
    inBands = ( D >= inner + semiBandWidthSq * (k-1)/nHeatBands & ...
                D <= inner + semiBandWidthSq * k/nHeatBands )  | ...
              ( D >= cupRadiusSq + semiBandWidthSq * (1-k/nHeatBands) & ...
                D <= outer + semiBandWidthSq * (1-(k-1)/nHeatBands) );
    Uinit(inBands) = bandTemps(k);
end % for
    
end % function
