function prc = gdpGpu(numPaths)
% GDPGPU simulates the GDP in the US
% 10 years from now, based on historic data.
%
% This version is fully vectorized and much faster than the original.
%
% Example:
%   >> gdpGpu(1e4)
% If this runs quickly, try more simulations.

% Load data and set parameters
load('usEconQuart.mat','usEcon');
GDP = usEcon.GDP;
numSteps = 40;

% Calculate logarithmic returns and fit to non-parametric distribution
logReturns = diff(log(GDP)); % same as log(GDP(2:end)./GDP(1:end-1));
myfit = fitdist(logReturns,'kernel');

% Call computation function and show histogram
simGDP = simulations(myfit,GDP(end),numSteps,numPaths);
histogram(simGDP,50)
title(['Final prices of ' num2str(numPaths) ' simulations'])
prc = prctile(simGDP,[1 5 10 50]);

function simData = simulations(myfit,startval,numSteps,numPaths)
% SIMULATIONS runs simulations based on historic data using
% random numbers generated from the log returns.

% Generate a matrix of uniform random numbers
simReturns = rand(numSteps,numPaths,'gpuArray');

% Obtain table of percentiles
x = 0.001:0.001:0.999;
y = icdf(myfit,x);

% Interpolate, using the inverse cumulative distribution function
simReturns = interp1(x,y,simReturns,'linear','extrap');

% Compute final prices
simData = startval*prod(exp(simReturns));

% Gather data
simData = gather(simData);
