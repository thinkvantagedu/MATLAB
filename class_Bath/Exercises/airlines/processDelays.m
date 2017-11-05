function intermHistInfo = processDelays(subds, edges)
% PROCESSDELAYS computes histogram counts for each month
t = read(subds);
f = @(x) {histcounts(x, edges)};
intermHistInfo = cell2mat(splitapply(f, t.DepDelay, t.Month));