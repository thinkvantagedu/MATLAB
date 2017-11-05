function X = singlePath(z0,theta0)
% SINGLEPATH creates one sonar wave path and plots results
% 
%   X = singlePath(z0,theta0)
%
% INPUTS:
% * z0      : Initial immersion (default: 5 m)
% * theta0  : Initial angle (default: 85)
%
% OUTPUTS:
% * X : matrix of state 6xn (each column represents a time-step)
%
% Example:
%  X = singlePath(5,10);
%

% DEFINE PARAMETERS
% Tend [s  ] : Time of end simulation (the simulation will end as soon as one
% end criteria is true)
% x0    [m  ] : Initial horizontal start of wave
% P0    [dB ] : Initial strench of wave
% Xend  [m  ] : Horizontal of end simulation
% Bathy [   ] : name of the bathycelerimetrie (sound velocity [m/s] vs
% immersion)
% depth [m  ] : ground of the sea
Tend = 20 ;
x0 = 0 ;
P0 = 220 ;
Xend = 1500 ;
Bathy = 'bathyNorthAtlantide' ;
depth = 2000 ;

% load the bathy
data = load('Bathy.mat',Bathy);
Bathy = data.(Bathy);

% construct the initial state vector
X0 = [x0;z0;1;theta0*pi/180;P0;0];

%
% <http://nareva.info/ssn_sonar/equation.htm to see propagate attenuation equation (sorry in french)>
%
% The real equation is 
% SE = SL + TS - 2*TL - NL + DI + PG - DT - PL   > 0   [dB]
% In the following ionly the following terms have been coded :
%
% *TL* : Transportation lost proportionnal to the log of the distance $TL =
% 20 log( r )$ 
% *NL* : Noise due to sea surface or sea ground

lostPerDistance   = @(dist) max(20*log(dist),0); % TL : [dB]

% Pseudo variable step ode12
dT = 1 ;
T = 0 ;
X = {X0};
count = 0 ;

dlMin = 1 ;
dlMax = 5 ;
dTMin = 0.02 ;
dTMax = 1 ;
countMax = 10 ;

% loops on time
while T(end)<Tend
    % borning dT between dTMin and dTMax
    dT = max(min(dT,dTMax),dTMin);
    
    % compare method ode1 with dT against 2 ode1 of dT/2 and adjust dT
    % if difference on [x,z] is too small or too big
    Xp05 = diffTraj(dT/2,X0,depth,Bathy);
    Xp10 = diffTraj(dT/2,Xp05,depth,Bathy);
    Xp1  = diffTraj(dT,X0,depth,Bathy);
    
    dl = norm(Xp1(1:2)-Xp10(1:2),'inf') ;
    
    count=count+1;
    if     dl < dlMin && dT < dTMax && count<countMax
        dT = dT * dlMin/ dl ;
    elseif dl > dlMax && dT > dTMin && count<countMax
        dT = dT * dlMax/ dl ;
    else
        T(end+1) = T(end)+dT ; %#ok<*AGROW>
        X0 = Xp10 ;
        X{end+1} = X0 ;
        % remove the lost due to distance in the save cell array
        % multiply by 2 (round trip)
        X{end}(5) = X{end}(5)-lostPerDistance(2*X{end}(6));
        % stop if no more sound or if x is too big
        if X{end}(5)<=0 || X{end}(1)>=Xend
            T(end+1) = Tend ;
            X{end+1} = X{end} ;
        end
        count = 0 ;
    end
end

% post treatment
X = cat(2,X{:});

function Xkp1 = diffTraj(dT,Xk,depth,Bathy)
%                     x
%  +-----------------> 
%  |
%  |
%  |
%  v
% z

%      | x(k)      |           | x(k) + dT * v(k) * sin(theta(k))      |
% Xk = | z(k)      |  X(k+1) = | z(k) + dT * v(k) * cos(theta(k))      |
%      | v(k)      |           | soundSpeed(zk)                        |
%      | theta(k)  |           | asin(v(k+1)/v(k)*sin(theta(k))        |
%      | noise(k)  |           | noise(k+1)                            |
%      | dist(k)   |           | dist(k) + sqrt((xkp1-xk)²+(zkp1-zk)²) |
xk       = Xk(1) ;
zk       = Xk(2) ;
vk       = Xk(3) ;
thetak   = Xk(4) ;
noise    = Xk(5) ;
distance = Xk(6) ;

vk = sign(vk)*speedFromBathy(zk,Bathy) ;

xkp1 = xk+dT*vk*sin(pi/2-thetak) ;
zkp1 = zk+dT*vk*cos(pi/2-thetak) ;

%%
% <http://nareva.info/ssn_sonar/equation.htm to see propagate attenuation equation (sorry in french)>
lostBySurfacePing = @(x,z) 61*(z<=10) ; % [dB] (wind speed between 10 and 15 knot + wave)
lostByFloorPing   = @(x,z) 30*(z>=depth-50) ; % [dB] (not idea at all)

distance = distance + norm([xkp1-xk;zkp1-zk]) ;

if zkp1<0
    % test overwater
    zkp1 = -zkp1 ;
    signSpeed = 1 ;
    noise = noise - lostBySurfacePing(xkp1,0);
elseif zkp1>depth
    % test under deepend of ocean
    signSpeed = -1 ;
    zkp1 = 2*depth - zkp1 ;
    noise = noise - lostByFloorPing(xkp1,zkp1);
else
    signSpeed = sign(vk) ;
end
    
% lost signal due to sea surface noise
% lost signal due to floor noise
noise = noise - lostByFloorPing(xkp1,zkp1) - lostBySurfacePing(xkp1,zkp1)  ;

vkp1 = signSpeed*speedFromBathy(zkp1,Bathy);
% in eqution theta is 0 when diving vertical at 100% so changin referential
% to be 0° if no diving (horizontal)
thetakp1 = pi/2-real(asin(vk*sin(pi/2-thetak)/vkp1)) ;

Xkp1 = [xkp1;zkp1;vkp1;thetakp1;noise;distance];

function [speed,acceleration] = speedFromBathy(immersion,bathy) 
% Too complicated to deal with but more completed model
% <http://pravarini.free.fr/Eaudemer.htm Underwater speed of sound> 
%
%
% speed       : sound speed [m/s]
%
% temperature : temperature [°C]
%
% salinity    : salinité    [g/kg]
%
% immersion   : depth       [m]
%
% speed = 1449.2 + 4.6 * temperature - 0.0557*temperature^2 + ...
%     0.000297*temperature^3 +(1.34 - 0.010*temperature)*(salinity-35) + ...
%     0.016 * immersion ;

% Bathy profile
% <http://archimer.ifremer.fr/doc/00017/12790/9731.pdf ifremer report (french)> 
%
% 
% <<..\exBathy.png>>
% 
speed = interp1(bathy(:,2),bathy(:,1),[immersion;immersion+1],'linear',...
    'extrap');
acceleration = speed(2);
speed = speed(1);
