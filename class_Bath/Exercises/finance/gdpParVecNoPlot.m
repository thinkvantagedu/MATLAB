function [prc, biny, binx]  = gdpParVecNoPlot(numPaths)
% GDPPARVECNOPLOT simulates the GDP in the US 
% 10 years from now, based on historic data.
%
% This version returns histogram data rather than displaying it.
%
% Example:
%   >> pp = parpool; % optional
%   >> [prc, biny, binx] = gdpParVecNoPlot(1e6);
%   >> delete(pp); % optional
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
[biny,binx] = histcounts(simGDP,50);
prc = prctile(simGDP,[1 5 10 50]);

function simData = simulations(myfit,startval,numSteps,numPaths)
% SIMULATIONS runs simulations based on historic data using
% random numbers generated from the log returns.

% Generate random numbers and compute final price
numParIter = 20;
numLocalRuns = ceil(numPaths/numParIter);

simData = nan(numLocalRuns,numParIter);
parfor k = 1:numParIter
    simReturns = random(myfit,numSteps,numLocalRuns);  
    simData(:,k) = startval*prod(exp(simReturns));
end
simData = simData(:);
