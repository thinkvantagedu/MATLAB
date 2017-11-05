function [posgp, weigp] = gaussq

const = 0.577350269189626;

posgp = [-const -const; const -const; const const; -const const];

weigp(1:4) = 1;