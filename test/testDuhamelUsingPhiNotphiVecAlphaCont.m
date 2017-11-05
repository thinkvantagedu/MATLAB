phisum = phif(:, 1) + phif(:, 2);

alphasum = (alpha(1, :) + alpha(2, :)) / 2;

fminit = zeros(nd, nt);
fminit(:, 1) = fminit(:, 1) + M * phisum;
fmstep = zeros(nd, nt);
fmstep(:, 2) = fmstep(:, 2) + M * phisum;

[uminit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fminit, acce, dT, maxT, U0, V0);
[umstep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fmstep, acce, dT, maxT, U0, V0);
um = zeros(nd, nt);
for i = 1:nt
    if i == 1
        um = um + uminit * alphasum(i);
    else
        ushift = [zeros(nd, i - 2) umstep(:, 1:nt - i + 2)];
        um = um + ushift * alphasum(i);
    end
end

fkinit = zeros(nd, nt);
fkinit(:, 1) = fkinit(:, 1) + K * phisum;
fkstep = zeros(nd, nt);
fkstep(:, 2) = fkstep(:, 2) + K * phisum;

[ukinit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fkinit, acce, dT, maxT, U0, V0);
[ukstep, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (Phi, M, C, K, fkstep, acce, dT, maxT, U0, V0);
uk = zeros(nd, nt);
for i = 1:nt
    if i == 1
        uk = uk + ukinit * alphasum(i);
    else
        ushift = [zeros(nd, i - 2) ukstep(:, 1:nt - i + 2)];
        uk = uk + ushift * alphasum(i);
    end
end

u = um + uk;
