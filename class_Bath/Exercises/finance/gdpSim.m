function prc = gdpSim(numPaths)
% GDPSIM simulates the GDP in the US 
% 10 years from now, based on historic data.
%
% This first version works but is poor in terms of performance.
%
% Example:
%   >> p = gdpSim(1e4)
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
    value = 1;
    for iInner = 1:numSteps
        simReturns = exp(random(myfit,1,1));
        value = value*simReturns;
    end
    simData(iOuter) = startval*value;
end
