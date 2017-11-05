function [part1, part2, part3, part4] = NewmarkAssembleLocalForcePart...
    (acce, dT, fce, M, C, K1120S0, K1021S0, K1020S1, U0, V0)
% part1
switch acce
    case 'average'
        beta = 1/4; gamma = 1/2; % al = alpha
    case 'linear'
        beta = 1/6; gamma = 1/2;
end

no_dof = length(M);
f0 = fce(:, 1);
f1 = fce(:, 2);

a3 = (1-gamma)*dT;
a4 = (1/2-beta)*dT^2;

part1 = [f1; -a3*M\f0-(-a3)*M\(C*V0)-V0; -a4*M\f0-(-a4)*M\(C*V0)-dT*V0-U0];

part2 = [zeros(no_dof, 1); -a3*M\(K1120S0*U0); -a4*M\(K1120S0*U0)];

part3 = [zeros(no_dof, 1); -a3*M\(K1021S0*U0); -a4*M\(K1021S0*U0)];

part4 = [zeros(no_dof, 1); -a3*M\(K1020S1*U0); -a4*M\(K1020S1*U0)];