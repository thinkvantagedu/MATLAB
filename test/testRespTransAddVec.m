clear; clc;
% this script tests computation of respTrans, if new vectors are added to
% the vector matrix, what happens to respTrans and how to deal with it?
% 2 cases: symmetric and non-symmetric.

% case 1: symmetric.
% the original vector matrix.
m = [1 2 3; 4 6 5; 3 5 2; 6 8 3];

mTm = m' * m;

% define new vectors.
mnv = [9 8 7 6; 8 7 6 4]';

% add to original one.
mn = [m mnv];

mnTmn = mn' * mn;

% reconstruct mnTmn without explicitly calculating mnTmn by using mTm.

part1 = triu(mTm);
part2 = m' * mnv;
part3 = triu(mnv' * mnv);

mnTmnRc = cell(2, 2);
mnTmnRc{1, 1} = part1;
mnTmnRc{1, 2} = part2;
mnTmnRc{2, 2} = part3;
mnTmnRc{2, 1} = zeros(size(part2, 2), size(part2, 1));
mnTmnRc = reConstruct(cell2mat(mnTmnRc));