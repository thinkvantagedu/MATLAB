% x decides the left to right range.
x = -1:0.01:1;
% shift moves the bell, + moves to left, - moves to right. 
shift = 0;
% sig controls 'width' of the bell shape.
sig = 0.1;
% efunc remains same size when changing sig.
efunc = - (x + shift) .^ 2 / 2 / sig ^ 2;

func = 1 / sqrt(2 * pi * sig ^ 2) * exp(efunc);

func = func / max(func);

plot(x, func);

hold on;