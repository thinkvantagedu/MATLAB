gridx = [10 10 ^ 1.5; 10 10 ^ 1.5];
gridy = [10 10; 10 ^ 1.5 10 ^ 1.5];

gridz = {[1 2 3; 3 4 5] [1 3 5; 5 7 9]; [2 3 4; 4 5 6] [2 4 6; 6 8 9]};

inptx = 10;
inpty = 10;
otpt = LagrangeInterpolation2Dmatrix(inptx, inpty, gridx, gridy, gridz);