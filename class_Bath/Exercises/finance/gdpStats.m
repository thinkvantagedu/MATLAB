function gdpStats(numPaths)
% GDPSTATS simulates the GDP in the US 
% 10 years from now, based on historic data.
%
% Example:
%   >> gdpStats(1e5)
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

figure
hold on
for k = 1:3
    histogram(simGDP(k,:),'EdgeColor','none')
end
hold off
ax = gca;
ax.Box = 'on';
legend('Minimum','Mean','Maximum')
title(['Prices of ' num2str(numPaths) ' simulations'])


function simData = simulations(myfit,startval,numSteps,numPaths)
% SIMULATIONS runs simulations based on historic data using
% random numbers generated from the log returns.

% Generate random numbers and compute final price
simData = nan(3,numPaths);
for k = 1:numPaths
    % Generate a vector of random numbers
    simReturns = random(myfit,numSteps,1);
    % (inner loop eliminated)
    prices = startval*cumprod(exp(simReturns));
    simData(1,k) = min(prices);
    simData(2,k) = mean(prices);
    simData(3,k) = max(prices);
end
