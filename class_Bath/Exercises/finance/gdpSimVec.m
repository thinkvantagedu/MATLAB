function prc = gdpSimVec(numPaths)
% GDPSIMVEC simulates the GDP in the US 
% 10 years from now, based on historic data.
%
% This version is vectorized and much faster than the original.
%
% Example:
%   >> p = gdpSimVec(1e4)
% 
% If this runs quickly, try more simulations.
% 

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

% Generate random numbers and compute final price
simData = nan(1,numPaths);
for iOuter = 1:numPaths
    simReturns = random(myfit,numSteps,1);
    simData(iOuter) = startval*prod(exp(simReturns));
end
