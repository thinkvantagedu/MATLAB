fceCell = rawStrCell{:}(lineFceStart + 1 : lineFceEnd - 2, :);
fceCell = cellfun(@(v) str2num(v), fceCell(:), 'un', 0);

fceNum = cell2mat(fceCell(1 : end - 1));
fceNum = fceNum';

fceNum = fceNum(2:2:end, :);
fceNum = fceNum(:);

