x = (-10:0.1:10);
y = (-10:0.1:10);
lag.loc = combvec(x, y);
lag.loc = lag.loc';

% lag.val = LagInterpolationOtptSingle(lin_coeff, lag.loc(:, 1), lag.loc(:, 2));

% lag.loc_val = [lag.loc lag.val];

height = zeros(length(x), length(y));

for i = 1:length(y)
    
    %     height(:, i) = height(:, i)+lag.loc_val((i*length(x)-length(x)+1):(i*length(x)), 3);
    height(:, i) = height(:, i)+LagInterpolationOtptSingle(lin_coeff, lag.loc(i, 1), lag.loc(i, 2));
    
end

surf(x, y, height');