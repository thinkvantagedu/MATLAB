clear; clc;
%%

u1 = (1:15)';

u2 = (2:16)';

u3 = (3:17)';

u = {u1 u2 u3};

usum = u1 + u2 + u3;

fnmusum = norm(usum, 'fro');
%%
ualg = cell2mat(u);

uatua = ualg' * ualg;

fnmua = sqrt(sum(uatua(:)));
%%

um = cellfun(@(v) reshape(v, [5, 3]), u, 'UniformOutput', false);

ucalg = cell2mat(um);

uctuc = ucalg' * ucalg;

ucCell = mat2cell(uctuc, 3 * ones(1, 3), 3 * ones(1, 3));

ucCeltra = cellfun(@(v) trace(v), ucCell, 'UniformOutput', false);

ucCeltra = cell2mat(ucCeltra);

ucCelsum = sqrt(sum(ucCeltra(:)));


%%

[ux, usig, uy] = cellfun(@(v) svd(v, 'econ'), um, 'UniformOutput', false);

uxy = {ux uy};

uxyalg = cellfun(@(v) cell2mat(v), uxy, 'UniformOutput', false);

uxytuxy = cellfun(@(v) v' * v, uxyalg, 'UniformOutput', false);

usize = 3 * ones(1, 3);

uxytuxy = cellfun(@(v) mat2cell(v, usize, usize), uxytuxy, 'UniformOutput', false);

uxtux = uxytuxy{1};

uytuy = uxytuxy{2};

uxdiag = cellfun(@(v) diag(v), uxtux, 'UniformOutput', false);

uydiag = cellfun(@(v) diag(v), uytuy, 'UniformOutput', false);



uxtra = cellfun(@(v) trace(v), uxtux, 'UniformOutput', false);

uytra = cellfun(@(v) trace(v), uytuy, 'UniformOutput', false);

uxyCell = {uxtra; uytra};

uxyVal = cellfun(@(v) cell2mat(v), uxyCell, 'UniformOutput', false);
