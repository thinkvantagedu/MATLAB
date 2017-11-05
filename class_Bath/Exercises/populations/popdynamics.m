function cycles = popdynamics (x0, R, rstep, numsteps, capacity)
% POPDYANMICS Provides number of cycles in population numbers
%
%    CYCLES = POPDYNAMICS(X0, R, RSTEP, NUMSTEPS, CAPACITY) Takes an
%    initial size for a population, a two-element vector containing a
%    starting reproduction rate and and ending reproduction rate to vary
%    over, the step size between rates, the number of time steps to run, 
%    and the carrying capacity of the environment.  The simulation 
%    calculates the number of individuals in the population each time step, 
%    and then analyzes the values once the system has reached steady state.
%    The number of cycles represents how the population size changes from
%    timestep to timestep.  A cycle of 1 indicates that the population 
%    remains roughly constant from step to step.  A cycle of 2 indicates 
%    the population changes between two different sizes.  Larger cycles
%    indicate chaotic behavior.
%
%    Example:
%    cycles = popdynamics(5000, [1.5 3.0], 1e-5, 1200, 10000);
%
%    Explores the cycles when varying the reproduction rate between 1.5 and
%    3.0 in steps of 1e-5.  The initial population size is 5000 individuals
%    and the carrying capacity of the environment is 10000 individuals.  
%    The simulation will run for 1200 time steps.
%

% Determine the number of rates used
numrates = floor((R(2) - R(1))/rstep) + 1;

% Preallocate memory for the results
cycles = zeros(1, numrates);

for index = 1:numrates

    % Calculate the rate for the current iteration
    rate = (index - 1) * rstep + R(1);

    % Calculate the population size for each time step
    value = calcpop(x0, rate, numsteps, capacity);

    % Get steady-state values (assume 50 iterations to steady state)
    values_ss = round(value(51:end));

    % Store the number of cycles in the steady-state values
    cycles(index) = length(unique(values_ss)); 

end



function x = calcpop (x0, rate, numsteps, capacity)
% CALCPOP Returns vector with individuals in a population at given timestep
%
%    X = CALCPOP(X0, RATE, NUMSTEPS, CAPACITY) Creates a vector X with the
%    number of individuals at in a population for each time step.  X0 is
%    the initial size of the population, rate is the reproduction rate,
%    numsteps are the number of time steps to take, and capacity represents
%    the carrying capacity of the environment.
%

% Preallocate memory for the output
x = zeros (numsteps, 1);

% Set the initial size of the population
x(1) = x0;

% Iterate through each timestep to calculate population size
for timestep = 2:numsteps

    x(timestep) = x(timestep - 1) + rate/capacity * ...
                  x(timestep - 1) * (capacity - x(timestep - 1));

end