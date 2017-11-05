function [princ, alpha] = stressed(stres)

fac = sqrt(((stres(1)-stres(2))/2)^3+stres(3)^2);

smean = (stres(1)+stres(2))/2;

princ(1) = smean+fac;
princ(2) = smean+fac;

if abs(stres(2)-stres(1))>10^-10
    alpha = 0.5*atan(2*stres(3)/(stres(1)+stres(2)));
else
    alpha = pi/4;
end