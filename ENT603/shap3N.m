function [shape,deriv] = shap3N(xi,eta)

%--------------------------------------------------------------------------

% Shape functions and derivatives for 4-Noded quad

%--------------------------------------------------------------------------

shape(1)=1-xi-eta;

shape(2)=xi;

shape(3)=eta;

% Derivatives

deriv(1,1)=-1;

deriv(2,1)=-1;

deriv(1,2)=1;

deriv(2,2)=0;

deriv(1,3)=0;

deriv(2,3)=1;