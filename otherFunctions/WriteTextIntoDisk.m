function [ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeWritten)
% ExistingFilename-->text, FiletoBeWritten-->file on disk
fid=fopen(FiletoBeWritten,'w');
    
    for i_insert=1:size(ExistingFilename, 1)
    
        fprintf(fid, '%s\n', ExistingFilename(i_insert, :));
    
    end

fclose(fid);