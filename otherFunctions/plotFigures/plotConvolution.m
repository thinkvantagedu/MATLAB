clc; clf;
nd = fixie.no.dof;
npoint = 252;
x = 0:fixie.time.step:fixie.time.max;
nt = fixie.no.t_step;


% the selected impulse response. 
respIni = fixie.resp.store.tDiff{2, 2, 1, 1};
respIni = respIni{1} * respIni{2} * respIni{3}';
respSuc = fixie.resp.store.tDiff{2, 2, 2, 1};
respSuc = respSuc{1} * respSuc{2} * respSuc{3}';
hold on
for ip = nt:-1:1
    % plot the responses reversely, such that the red and blue curves are
    % on the top of other curves.
    if ip ~= 1 && ip ~= 2
        ufkshift = [zeros(nd, ip - 2) respSuc(:, 1:(nt - ip + 2))];
        hshift = plot(x, ufkshift(npoint, :), 'Color', [0.5 0.5 0.5]);
        hshift.LineWidth = 0.5;
    elseif ip == 2
        ufkshift = [zeros(nd, ip - 2) respSuc(:, 1:(nt - ip + 2))];
        hshift2 = plot(x, ufkshift(npoint, :), 'r');
        hshift2.LineWidth = 3;
    elseif ip == 1
        hinit = plot(x, respIni(npoint, :), 'b');
        hinit.LineWidth = 3;
    end
    
end

% node 126 is coord (45, 0), which is the lower center of the beam. DoF 252
% is y-displacement.
% figure(2)
% plot(x, respIni(npoint, :), 'b-.', 'LineWidth', 3)
uin = 'Initial response';
usu2 = 'Successive response';
usu = 'Successive responses from shift';
legend([hinit hshift2 hshift], uin, usu2, usu, 'Interpreter', 'latex');
xlabel('time')
ylabel('displacement')
set(gca, 'FontSize', 40)
grid minor









