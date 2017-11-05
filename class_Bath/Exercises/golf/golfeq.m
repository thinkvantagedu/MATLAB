function accel = golfeq(t,vel,vwind)
% GOLFEQ Differential equation for velocity of a golf ball
%
%   This function is to be called by a differential equation solver.
%
% See also ode45

K = 0.001;   % Constant for calculating drag
m = 0.045;   % Mass of a golf ball

% The differential equation describing the golf ball motion.
accel = -K/m * (vel + vwind) .^ 2;
