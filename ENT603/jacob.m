function [detJ,cartd] = jacob(elcod,deriv)

%--------------------------------------------------------------------------

% Evaluate element jacobian and its inverse

%--------------------------------------------------------------------------

% Jacobian

jac=deriv*elcod;

% Explicit form of Jacobian

x=elcod(:,1) ; y=elcod(:,2);

jacexp=[(x(2)-x(1)) (y(2)-y(1)) ; ...

(x(3)-x(1)) (y(3)-y(1))] ;

jacdif=jac-jacexp;

disp('error in jac')

disp(jacdif)

% Determinate of Jacobian

detJ=det(jac);

if detJ<=0

disp('Negative Jacobian')

end

% Inverse

jaci=inv(jac);

% Cartesian derivatives

cartd=jaci*deriv;