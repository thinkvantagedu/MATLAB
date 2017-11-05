x = 1:5;
y = 1:5;
load('test.mat')
axi_lim = [0 0.0007];
for i = 1:4
  hAx(i)=subplot(1, 4, i);  % save the axes handles always
  surf(x, y, errPreStore{i});
end
set(hAx,'zscale','log')
axis(hAx,'square')
axis(hAx,'tight', 'manual')
set(hAx,'zlim',axi_lim)

