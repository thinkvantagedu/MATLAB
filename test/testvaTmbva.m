% this script test:
% ma = triu(vaTva), mc = triu(vbTvb) .* ma, md = vbT ma vb, does md = mc?

clear; clc;
% generate symmetric matrix.
va = [2 4 3]';

ma = triu(va * va');

% case 1: use matrix product.
vb = [5 4 2]';

mb = triu(vb * vb');

mab = ma .* mb;

prodab = sum(mab(:));

% case 2: use vbT ma vb.
scalab = vb' * ma * vb;

% case 3: one more vector involved, use matrix product. 
vc = [1 2 3]';

mc = triu(vc * vc');

mabc = mab .* mc;

prodabc = sum(mabc(:));

% case 4: use (vc .* vb)T ma vb vc.

scalabc = (vc .* vb)' * ma * (vb .* vc);

% conclusion: all passed.