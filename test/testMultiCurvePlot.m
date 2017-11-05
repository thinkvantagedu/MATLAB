clear; clc;
t = -pi : .1 : pi;
x = sin(t);
y = cos(t);
plot(t,x,'r--o'); hold on;
plot(t,y,'b--*');