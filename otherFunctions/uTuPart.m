function otpt = uTuPart(nVeci, nVecj, respi, respj, shape)
% this function compute the part of eTe, either square and rectangular, or
% triangular, change in input 'shape'.

otpt = zeros(nVeci, nVecj);
for iTr = 1:nVeci
    u1 = respi{iTr};
    nQt = size(u1{3}, 1);
    switch shape
        case 'rectangle'
            jStart = 1;
        case 'triangle'
            jStart = iTr;
    end
    for jTr = jStart:nVecj
        u2 = respj{jTr};
        if u1{2}(1) == 0 || u2{2}(1) == 0
            otpt(iTr, jTr) = 0;
        else
            %% 1. trace.
            otpt_ = trace((u2{3}' * u1{3}) * u1{2}' * (u1{1}' * u2{1}) * u2{2});
            %% 2. no trace, sum.
%             oDiag = zeros(nQt, 1);
%             v1s = u1{2} * u1{3}';
%             v2s = u2{2} * u2{3}';
%             for io = 1:nQt                
%                 oDiag(io) = (u1{1} * v1s(:, io))' * (u2{1} * v2s(:, io));
%             end
%             otpt_ = sum(oDiag);
            %% output.
            otpt(iTr, jTr) = otpt_;
        end
    end
end
end