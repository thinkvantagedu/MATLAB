% this script plots impulse response of a single DoF after
% callFixiePODonRvDamping is finished. This is to be put in thesis Duhamel
% integral section. 

% the selected impulse, 11th. 
np = 11;
x = 0:fixie.time.step:fixie.time.max;
impulse = fixie.imp.store.mtx{2, 1};
figure(1)
plot(x, impulse(252, :), 'k', 'LineWidth', 3)
xlabel('time')
ylabel('force amplitude')
set(gca, 'FontSize', 30)
grid on

% the selected impulse response. 
response = fixie.resp.store.tDiff{np};
response = response{1} * response{2} * response{3}';

% node 126 is coord (45, 0), which is the lower center of the beam. DoF 252
% is y-displacement.
figure(2)
plot(x, response(252, :), 'b-.', 'LineWidth', 3)
xlabel('time')
ylabel('displacement')
set(gca, 'FontSize', 30)
grid on
