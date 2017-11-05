clear; clc;

for k = 1:100
  pause(0.01);
  CmdWinTool('statusText', sprintf('Progress: %d of %d', k, 100));
end