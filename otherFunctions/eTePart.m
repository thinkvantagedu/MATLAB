function otpt = eTePart(nVeci, nVecj, respi, respj, shape)
% this function compute the part of eTe, either square and rectangular, or
% triangular, change in input 'shape'. 

otpt = zeros(nVeci, nVecj);
for iTr = 1:nVeci
    u1 = respi{iTr};
    switch shape
        case 'rectangle'
            jStart = 1;
        case 'triangle'
            jStart = iTr;
    end
    for jTr = jStart:nVecj
        u2 = respj{jTr};
        otpt(iTr, jTr) = ...
            trace((u2{3}' * u1{3}) * u1{2}' * (u1{1}' * u2{1}) * u2{2});
    end
end