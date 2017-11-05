function percentiles(numPaths)
% This function simulates the GDP in the US
% for the next 10 years, based on historic data.
%
% Example:
%   >> percentiles(1e5)
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
prc = [99 95 50 5 1];
prcData = simulations(myfit,GDP(end),numSteps,numPaths,prc);

plot(prcData)
xlabel('Time')
ylabel('Price')
title('Percentile curves')
legend(num2str(prc'), 'location', 'NW')

function prcTS = simulations(myfit,startval,numSteps,numPaths,prc)
% SIMULATIONS runs simulations based on historic data using
% random numbers generated from the log returns.

% Generate random numbers and compute final price
% (alls loop eliminated)
simReturns = random(myfit,numSteps,numPaths);
simData = startval*cumprod(exp(simReturns));

% Find percentiles
prcTS = prctile(simData,prc,2);
