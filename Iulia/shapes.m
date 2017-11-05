function [shape,deriv] = shapes(xi,eta)

%--------------------------------------------------------------------------

% Shape functions and derivatives for 4-Noded quad

%--------------------------------------------------------------------------

shape(1)=0.25*(1-xi)*(1-eta);

shape(2)=0.25*(1+xi)*(1-eta);

shape(3)=0.25*(1+xi)*(1+eta);

shape(4)=0.25*(1-xi)*(1+eta);
% Derivatives

deriv(1,1)=-0.25*(1-eta);

deriv(2,1)=-0.25*(1-xi);

deriv(1,2)=0.25*(1-eta);

deriv(2,2)=-0.25*(1+xi);

deriv(1,3)=0.25*(1+eta);

deriv(2,3)=0.25*(1+xi);

deriv(1,4)=-0.25*(1+eta);

deriv(2,4)=0.25*(1-xi);