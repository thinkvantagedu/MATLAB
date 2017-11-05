function [subdsSums, subdsSummedSquares, subdsNumObs] = processPrices(subds)
% PROCESSPRICES computes sums, squared sums, and number of observations for
% a sub-datastore
t = read(subds);
prices = table2array(t);
returns = diff(log(prices));
subdsSums = sum(returns);
subdsSummedSquares = sum(returns.^2);
subdsNumObs = size(returns,1);