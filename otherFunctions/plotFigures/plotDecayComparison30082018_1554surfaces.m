plotData;
cd ~/Desktop/Temp/thesisResults/30082018_1554_residual/;

load('errOriginalTrial1.mat', 'errOriginalTrial1');
load('errProposedTrial1.mat', 'errProposedTrial1');
load('errResidualTrial1.mat', 'errResidualTrial1');

pm1 = logspace(-1, 1, 17);
pm2 = logspace(-1, 1, 17);

