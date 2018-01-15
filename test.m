clear; clc; 

ni = 2;
nj = 1;
nr = 2;
nt = 3;
nd = 2;

% follow ni, nj, nr, nt. 
u1111 = [1 2 3 4 5 6]';
u1112 = [2 3 5 4 1 6]';
u1113 = [6 5 4 3 2 1]';
u1121 = [2 4 3 5 1 6]';
u1122 = [6 4 5 3 1 2]';
u1123 = [5 4 6 3 2 1]';

u2111 = [1 3 4 2 5 6]';
u2112 = [1 4 5 3 2 6]';
u2113 = [2 3 5 4 1 6]';
u2121 = [2 6 5 3 1 4]';
u2122 = [3 4 6 5 1 2]';
u2123 = [5 6 4 2 3 1]';

e1 = [u1111 u1112 u1113 u1121 u1122 u1123];
e2 = [u2111 u2112 u2113 u2121 u2122 u2123];

a3 = [9 7 8 5 3 6]';
xc = [1 5];
inptx = 4;

%% interpolate u, multiply alpha then norm.
ycu = {e1 e2};
otptu = lagrange(xc, ycu, inptx, 'matrix');
otptnm = sqrt(a3' * (otptu)' * otptu * a3);         %|
% otptnmsq = zeros(6, 1);                           %|
% for i = 1:6                                       %|same operation
%     otptnmsq = otptnmsq + otptu(:, i) * a3(i);    %|
% end                                               %|
% otptnm = norm(otptnmsq, 'fro');                   %|
%% interpolate eTe, then multiply alpha. This is not correct.
e1te1 = e1' * e1;
e2te2 = e2' * e2;
yce = {e1te1 e2te2};
otpte = lagrange(xc, yce, inptx, 'matrix');
otptete = a3' * otpte * a3;
otptetenm = sqrt(otptete);

%% Test what should be correct.
lagCoef = [0.25; 0.75];
eC = {e1; e2};
cTc = lagCoef * lagCoef';
ectec = cell(2, 2);
for i = 1:2
    for j = 1:2
        ectec{i, j} = eC{i}' * eC{j};
    end
end

eteotpt1 = zeros(6, 6);
for i = 1:4
    eteotpt1 = eteotpt1 + ectec{i} * cTc(i);
end
eteotpt = sqrt(a3' * eteotpt1 * a3);