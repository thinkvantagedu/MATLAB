function percentilesBigData(numPaths)
% PERCENTILESBIGDATA simulates the GDP in the US
% for the next 10 years, based on historic data.
%
% Example:
%   >> parpool
%   >> percentilesBigData(1e5)
%   >> delete(gcp)
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
spmd  
    % TODO: utilize codistributor1d.defaultPartition to find 
    % the number of paths (columns) to be simulated by each lab
    
    % TODO: In the following line, insert the number of paths (columns)
    simReturns = random(myfit,numSteps,       );
    simData = startval*cumprod(exp(simReturns));
    
    % TODO: Use codistributor1d to create a column-oriented distribution 
    % scheme for a numSteps-by-numPaths codistributed array
                             
    % TODO: Convert simData into a codistributed array, 
    % using the distribution scheme created in the previous step
    
    % TODO: Use codistributor1d to create a row-oriented distribution 
    % scheme for a numSteps-by-numPaths codistributed array
    
    % TODO: Redistribute simData using the distribution scheme 
    % created in the previous step
    
    % TODO: Compute percentiles on local data
      
end

% TODO: Vertically concatenate the percentile timeseries, converting from a
% composite array to a double array
