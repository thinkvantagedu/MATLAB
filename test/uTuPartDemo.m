function otpt = uTuPartDemo(respi, respj)

otpt = zeros(length(respi), length(respj));

for iTr = 1:length(respi)
    u1 = respi{iTr}; % find the ith cell element.
    for jTr = 1:length(respj)
        u2 = respj{jTr}; % find the jth cell element
        otpt(iTr, jTr) = ... % compute the trace.
            trace((u2{3}' * u1{3}) * u1{2}' * (u1{1}' * u2{1}) * u2{2});
        keyboard
    end
end