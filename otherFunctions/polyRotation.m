function otpt = polyRotation(inpt, direction)
% this function re-arrange polygon tip coordinates into clockwise
% (cw) or counter-clockwise (ccw).
x = inpt(:, 1);
y = inpt(:, 2);
mx = mean(x);
my = mean(y);
switch direction
    case 'cw'
        ang = atan2(x - mx, y - my);
    case 'ccw'
        ang = atan2(y - my, x - mx);
end
[~, order] = sort(ang);
otpt(:, 1) = x(order);
otpt(:, 2) = y(order);
end