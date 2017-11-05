clear variables; clc;
% this script discovers the way in GSA interpolation to only use 2 
% space-time response vectors to generate the error scalar matrix 
% (the one being summed), instead of using no.t vectors. 

% a = [0 0 0 0;
%     0 0 0 0;
%     0 0 0 0;
%     1 2 0 0;
%     2 3 0 0;
%     3 6 0 0;
%     4 1 2 0;
%     5 5 3 0;
%     6 4 6 0;
%     7 9 1 2;
%     8 2 5 3;
%     9 1 4 6];
% 
% c = [0 0;
%     0 0;
%     0 0;
%     1 2;
%     2 3;
%     3 6;
%     4 1;
%     5 5;
%     6 4;
%     7 9;
%     8 2;
%     9 1];

a = [0 0 0 0 0 0; 
    0 0 0 0 0 0 ;
    1 2 0 0 0 0 ;
    2 7 0 0 0 0 ;
    3 3 2 0 0 0 ;
    4 5 7 0 0 0 ;
    5 1 3 2 0 0 ;
    6 1 5 7 0 0 ;
    7 9 1 3 2 0 ;
    8 6 1 5 7 0 ; 
    9 2 9 1 3 2 ;
    2 3 6 1 5 7];

c = [0 0 1 2 3 4 5 6 7 8 9 2;
    0 0 2 7 3 5 1 1 9 6 2 3]';

no_t = size(a, 2);
no_dof = size(a, 1) / no_t;

% the test case, atrans is the target. The old way is to generate no.t
% space-time vectors and perform combination. This method generates loads
% of unnecessary information and cost loads of storage. 
atrans = a' * a;

% b is reshape a to space vectors, and perform combination, result needs to
% be summed for each block.
b = reshape(a, [no_dof, numel(a) / no_dof]);
btrans = b' * b;

% c is the new method, only store 2 space and time vectors, generate
% essential information, then recast atrans. 
d = reshape(c, [no_dof, numel(c) / no_dof]);
% dtrans contains all the information needed. 
dtrans = d' * d;
% separate dtrans into blocks. 
dtransblk = mat2cell(dtrans, [no_t, no_t], [no_t, no_t]);

blkinit = dtransblk(1);
blkboth = dtransblk(2);
blkstep = dtransblk(4);

% for blk 1, only needs diagnoal line sum information. 
blkinitMaindiagsum = sum(diag(blkinit{:}));
% for blk 2, need the sum of upper triangle. 
blkbothAlldiagsum = sumDiagSqMTXAll(blkboth{:});
blkbothUpTridiagsum = flipud(blkbothAlldiagsum(2:no_t));
% assemble the first line of resulting scalar matrix. 
blkfirstline = [blkinitMaindiagsum blkbothUpTridiagsum'];

% all the rest info is in blkboth. 
blkstepSum = cell(no_t - 1, 1);
for i_step = 1:(no_t - 1)
    
    blkstepTemp = blkstep{:}(1:(no_t - i_step + 1), 1:(no_t - i_step + 1));
    n1 = length(blkstepTemp);
    blkstepSumTemp = sumDiagSqMTXAll(blkstepTemp);
    
    blkstepSumTemp = blkstepSumTemp(2: n1);
    
    blkstepSum(i_step) = {[zeros(1, i_step) (flipud(blkstepSumTemp))']};
    
end

% put them in one cell. 

final = [{blkfirstline}; blkstepSum];

final = cell2mat(final);
% test of shrter vector and longer vector products.
% a1 = rand(3612, 3011);
% a2 = rand(12, 6321);
% 
% tic
% b1 = a1'*a1;
% toc
% 
% tic
% b2 = a2'*a2;
% toc















