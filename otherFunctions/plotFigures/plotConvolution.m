clear; clc;
%%
nd = 2;
nt = 40;
x = 1:nt;
acce = 'average';
dt = 0.1;
maxt = dt * (nt - 1);
k = [6 -2; -2 4];
m = [2 0; 0 1];
c = [0 0; 0 0];
%%

u0 = [0; 0];
v0 = [0; 0];

phi = [3 2; 1 4];



%% original theory: impulse = K * phivec.
kphi1 = k * phi(:, 1);
kphi2 = k * phi(:, 2);

% set up initial and successive impulses.
fk1init = zeros(nd, nt);
fk1init(:, 1) = fk1init(:, 1) + kphi1;

fk1after = zeros(nd, nt);
fk1after(:, 2) = fk1after(:, 2) + kphi1;
%
fk2init = zeros(nd, nt);
fk2init(:, 1) = fk2init(:, 1) + kphi2;

fk2after = zeros(nd, nt);
fk2after(:, 2) = fk2after(:, 2) + kphi2;

% apply impulses on system
phiid = eye(2);

[ufk1init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fk1init, acce, dt, maxt, u0, v0);

[ufk1after, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fk1after, acce, dt, maxt, u0, v0);

[ufk2init, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fk2init, acce, dt, maxt, u0, v0);

[ufk2after, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fk2after, acce, dt, maxt, u0, v0);

% apply translation, reconstruct solutions.

ufk1 = zeros(nd, nt);
for i = 1:nt
    
    if i == 1
        ufk1 = ufk1 + ufk1init;
    else
        ufk1shift = [zeros(nd, i - 2) ufk1after(:, 1:(nt - i + 2))];
        ufk1 = ufk1 + ufk1shift;
    end
    
end


%% implementation: force = K * Phi.
kphi = k * phi;

fkinit = zeros(nd, nt + 1);
fkinit(:, 1:nd) = fkinit(:, 1:nd) + kphi;

fkafter = zeros(nd, nt + 1);
fkafter(:, nd + 1: nd * 2) = fkafter(:, nd + 1 : nd * 2) + kphi;

[ufkinit, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fkinit, acce, dt, maxt, u0, v0);

[ufkafter, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
    (phiid, m, c, k, fkafter, acce, dt, maxt, u0, v0);

%% compute alpha
alpha = sin(1:40) + 2;

hold on
ufk = zeros(nd, nt);
for j = 1:nt / nd
    
    if j == 1
        hinit = plot(x-1, 3 * ufkinit(1, :), 'r');
        halpha =scatter(j - 1, alpha(1, j), 100, 'k', '+');
        ufk = ufk + ufkinit;
        hinit.LineWidth = 2;
        halpha.LineWidth = 2;
    elseif j == 2
        
        ufkshift = [zeros(nd, nd * (j - 2)) 3 * ufkafter(:, 1:(nt - nd * j + 4))];
        hshift2 = plot(x, ufkshift(1, :), 'b');
        halpha =scatter(j * 2 - 2, alpha(1, j), 100, 'k', '+');
        ufk = ufk + ufkshift;
        hshift2.LineWidth = 2;
        halpha.LineWidth = 2;
    else
        ufkshift = [zeros(nd, nd * (j - 2)) 3 * ufkafter(:, 1:(nt - nd * j + 4))];
        hshift = plot(x, ufkshift(1, :), '-.b');
        halpha =scatter(j * 2 - 2, alpha(1, j), 100, 'k', '+');
        ufk = ufk + ufkshift;
        hshift.LineWidth = 2;
        halpha.LineWidth = 2;
    end
end

axis([0 40 -5 5])

ftsize = 20;

xla = xlabel('time');
yla = ylabel('amplitude');
xla.FontSize = ftsize;
yla.FontSize = ftsize;

uin = 'Initial response';
usu2 = 'Successive response';
usu = 'Successive responses from shift';
alphah = 'reduced variables';
lgd = legend([hinit hshift2 hshift halpha], uin, usu2, usu, alphah, 'Interpreter', 'latex');
lgd.FontSize = ftsize;

set(gca,'xticklabel',{[]})
set(gca,'yticklabel',{[]})

grid on










