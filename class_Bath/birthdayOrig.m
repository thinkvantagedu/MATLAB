function match = birthdayOrig(groupsize)
% BIRTHDAYORIG Simulates a single trial of the Birthday Paradox
%    MATCH = BIRTHDAYORIG(GROUPSIZE) creates a randomly selected birthday
%    for every member of a group of size GROUPSIZE and tests whether any of
%    the selected birthdays match.  MATCH is true if two or more members of
%    the group share the same birthday and false otherwise.
%
%    Example:
%    match = birthdayOrig(30)

% Match is false until a birthday match is found
match = false;

% Initialize list of taken birthdays
bdaylist = zeros(1,groupsize);

for person = 1:groupsize
    % Randomly select a birthdate for the individual (ignore leap years)
    birthdate = randi(365);

    % Check if someone else in the group shares the same birthday
    if any(birthdate == bdaylist)
        % A match is found, return from the function
        match = true;
        return
    end

    % Add the birthdate to the list for the group
    bdaylist(person) = birthdate;
end
