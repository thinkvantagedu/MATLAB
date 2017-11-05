function gdpStatsParFcn(numPaths)
% GDPSTATSPARFCN simulates the GDP in the US 
% 10 years from now, based on historic data.
%
% Example:
%   >> p = parpool; % optional
%   >> gdpStatsParFcn(1e5)
%   >> delete(p); % optional
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
simData = nan(3, numPaths);
parfor k = 1:numPaths
    simData(:,k) = singleSimulation(myfit,startval,numSteps);
end

function simData = singleSimulation(myfit,startval,numSteps)
simReturns = random(myfit,numSteps,1);
prices = startval*cumprod(exp(simReturns));
simData = [ min(prices) ; mean(prices) ; max(prices) ];
