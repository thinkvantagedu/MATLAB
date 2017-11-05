function statsMapper(data,~,intermKVStore)
% STATSMAPPER computes intermediate sums, sums of squares, and counts 
% for a portion of the data

% Variable names are key values
intermKey = data.Properties.VariableNames;

% For each country, run the local function computation
f = @computation;
intermData = varfun(f, data, 'OutputFormat', 'cell');

% Use addmulti to add keys and values
addmulti(intermKVStore,intermKey,intermData); 


function y = computation(x)
x = diff(log(x));
y =[sum(x), sum(x.^2), numel(x)];
