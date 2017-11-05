function Uinit = initialTempDistrib(nPoints)

% Initialize the grid at room temperature.
roomTemp = 23;
Uinit = roomTemp * ones(nPoints+2);

% Center and radius of the coffee cup.
gridCenter = round(size(Uinit)/2); % The middle of the grid.
cupRadiusSq = round(size(Uinit, 1)/4).^2; % A quarter of the grid dimension, squared.

% Assume that placing the cup on the grid provides an initial heat
% distribution at the immediate contact points. In reality, placing the cup of
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

% Initialize the bands of heat caused by the placement of the cup.
for k = 1:nHeatBands
    inBands = ( D >= inner + semiBandWidthSq * (k-1)/nHeatBands & ...
                D <= inner + semiBandWidthSq * k/nHeatBands )  | ...
              ( D >= cupRadiusSq + semiBandWidthSq * (1-k/nHeatBands) & ...
                D <= outer + semiBandWidthSq * (1-(k-1)/nHeatBands) );
    Uinit(inBands) = bandTemps(k);
end % for
    
end % function