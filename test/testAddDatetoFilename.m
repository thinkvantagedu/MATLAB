clear variables; clc;

data = rand(5);

pm = [1 1];

dataloc = ['/home/xiaohan/Desktop/[%d_%d] test', ...
    datestr(now, ' mmm.dd,yyyy HH:MM:SS'), '.mat'];
datafile_name = sprintf(dataloc, pm(1), pm(2));
save(datafile_name, 'data')