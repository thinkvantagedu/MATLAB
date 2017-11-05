function prob = runBirthdayOrig(numtrials,groupsize)
% RUNBIRTHDAYORIG Runs a Monte Carlo simulation using the Birthday Paradox
% code
%    PROB = RUNBIRTHDAYORIG(NUMTRIALS, GROUPSIZE) Calls the birthday code
%    NUMTRIALS times to see if any birthdays match in a group of size
%    GROUPSIZE.  The return value is the probability that a match will be
%    found.
%
%    Example:
%    p = runBirthdayOrig(100,60)

for trial = 1:numtrials
    % Run a simulation for a group
    matches(trial) = birthdayOrig(groupsize);
end

% Probability is the sum of matches divided by number of trials
prob = sum(matches)/numtrials;
