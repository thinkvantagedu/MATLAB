clear; clc; clf;
% this script tests Van der Corput sequence. 

% function VanderCorput(idx, base)
% generate Van der Corput sequence in [0 1].
idx = 15;
base = 2;
v = VanderCorput(idx, base);
v = [v; 1];

% expand to [-1 1] range.

pm = -1 + v * 2;

%% plot N iterations of Van der Corput sequence in [-1 1].
scatter(0, 0, 'filled')
hold on
for ip = 0:15
    
    v1 = VanderCorput(ip, base);
    v1 = [v1; 1];
    v1 = -1 + v1 * 2;
    scatter(v1, ip * ones(ip + 2, 1) + 1, 'filled');
    hold on
    
end

axis square
grid on