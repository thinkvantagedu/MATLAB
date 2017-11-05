clear variables; clc;

x = 0:10; 
y1 = sin(x); 
y2 = 2*sin(x);
y = [y1;y2]';
xi = 0:.25:10; 
yi = interp1(x,y,xi); 
figure
plot(x,y,'o',xi,yi)