function C = getit(C)
% extract and concatenate cell array of cell arrays.
while any(cellfun('isclass',C,'cell'))
        C = cat(2,C{:});
end