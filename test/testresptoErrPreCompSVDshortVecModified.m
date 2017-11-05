% test a scaled model for method resptoErrPreCompSVDshortVec.

clear; clc;

nd = 4;
nrb = 1;
nphy = 2;
nt = 3;
nf = 1;
nsvd = 2;
nshift = nt - 1;

u1 = (1:12)';
u2 = u1 + 1;
u3 = [zeros(nd, 1); u2(1 : end - nd)];
u4 = [zeros(nshift * nd, 1); u2(1:end - nd * nshift)];
u5 = u1 + 5;
u6 = u1 - 2;
u7 = [zeros(nd, 1); u6(1 : end - nd)];
u8 = [zeros(nshift * nd, 1); u6(1:end - nd * nshift)];
uf = u1 - 6;

respPmPass = cell(1, nrb, nphy, nt + 1);
respPmPass{1, 1, 1, 1} = u1;
respPmPass{1, 1, 1, 2} = u2;
respPmPass{1, 1, 1, 3} = u3;
respPmPass{1, 1, 1, 4} = u4;
respPmPass{1, 1, 2, 1} = u5;
respPmPass{1, 1, 2, 2} = u6;
respPmPass{1, 1, 2, 3} = u7;
respPmPass{1, 1, 2, 4} = u8;

%% the original eTe.

resp = cat(2, respPmPass{:});
resp = [uf resp];

ete = resp' * resp;

ete = triu(ete);

%% original with all time;
% process force.
uf = reshape(uf, [nd, nt]);
[respFceL, respFceSig, respFceR] = svd(uf, 'econ');
uf = reshape(uf, [nd * nt, 1]);

% process pm.

respPmSpaceTime = cellfun(@(v) reshape(v, [nd, nt]), respPmPass, ...
    'UniformOutput', false);

[respPmL, respPmSig, respPmR] = cellfun(@(v) svd(v, 'econ'), ...
    respPmSpaceTime, 'UniformOutput', false);

respLresh = reshape(respPmL, [nrb * nphy * (nt + 1), 1]);
respLresh = [{respFceL}; respLresh];
respSigresh = reshape(respPmSig, [nrb * nphy * (nt + 1), 1]);
respSigresh = [{respFceSig}; respSigresh];
respRresh = reshape(respPmR, [nrb * nphy * (nt + 1), 1]);
respRresh = [{respFceR}; respRresh];

respTrans = zeros(nrb * nphy * (nt + 1) + 1);

for i = 1:nrb * nphy * (nt + 1) + nf
    for j = 1:nrb * nphy * (nt + 1) + nf
        respPass = 0;
        
        l1 = respLresh{i}(:, 1:nsvd) * respSigresh{i}(1:nsvd, 1:nsvd);
        l2 = respLresh{j}(:, 1:nsvd) * respSigresh{j}(1:nsvd, 1:nsvd);
        r1 = respRresh{i}(:, 1:nsvd);
        r2 = respRresh{j}(:, 1:nsvd);
        
        respPass = respPass + sum(diag(r2' * r1 * l1' * l2));
        respTrans(i, j) = respTrans(i, j) + respPass;
    end
end
respTrans = triu(respTrans);

%% implementation with part time.

respPmPass1 = cell(1, nrb, nphy, 2);
respPmPass1{1, 1, 1, 1} = u1;
respPmPass1{1, 1, 1, 2} = u2;

respPmPass1{1, 1, 2, 1} = u5;
respPmPass1{1, 1, 2, 2} = u6;


respPmSpaceTime1 = cellfun(@(v) reshape(v, [nd, nt]), respPmPass1, ...
    'UniformOutput', false);

[respPmL1, respPmSig1, respPmR1] = cellfun(@(v) svd(v, 'econ'), ...
    respPmSpaceTime1, 'UniformOutput', false);

respLresh1 = reshape(respPmL1, [nrb * nphy * 2, 1]);
respLresh1 = [{respFceL}; respLresh1];
respSigresh1 = reshape(respPmSig1, [nrb * nphy * 2, 1]);
respSigresh1 = [{respFceSig}; respSigresh1];
respRresh1 = reshape(respPmR1, [nrb * nphy * 2, 1]);
respRresh1 = [{respFceR}; respRresh1];

nbase = nrb * nphy * 2 + 1;
nall = nrb * nphy * (nt + 1) + 1;

% ete part 1.
resp1 = zeros(nbase);
for i = 1:nbase
    for j = i:nbase
        respPass1 = 0;
        
        l1 = respLresh1{i}(:, 1:nsvd) * respSigresh1{i}(1:nsvd, 1:nsvd);
        l2 = respLresh1{j}(:, 1:nsvd) * respSigresh1{j}(1:nsvd, 1:nsvd);
        r1 = respRresh1{i}(:, 1:nsvd);
        r2 = respRresh1{j}(:, 1:nsvd);
        
        respPass1 = respPass1 + sum(diag(r2' * r1 * l1' * l2));
        resp1(i, j) = resp1(i, j) + respPass1;
    end
end

% ete part 2.
resp2 = zeros(nbase, nall - nbase);
for i = 1:nbase
    ind = 1;
    for j = 1:nshift
        for l = (nall - nbase):nbase
            
            respPass2 = 0;
            
            l1 = respLresh1{i}(:, 1:nsvd) * respSigresh1{i}(1:nsvd, 1:nsvd);
            l2 = respLresh1{l}(:, 1:nsvd) * respSigresh1{l}(1:nsvd, 1:nsvd);
            r1 = respRresh1{i}(:, 1:nsvd);
            r2 = [zeros(j, nsvd); respRresh1{l}(1:nt - j, 1:nsvd)];
            
            
            respPass2 = respPass2 + sum(diag(r2' * r1 * l1' * l2));
            resp2(i, ind) = resp2(i, ind) + respPass2;
            ind = ind + 1;
            
        end
        
    end
end

% ete part 3.

resp3 = zeros(nall - nbase);
indj = 1;
for l = 1:nshift
    for j = 4:nbase
        indi = 1;
        for k = 1:nshift
            for i = 4:nbase
                respPass3 = 0;
                
                if indi <= indj
                    
                    l1 = respLresh1{i}(:, 1:nsvd) * respSigresh1{i}(1:nsvd, 1:nsvd);
                    l2 = respLresh1{j}(:, 1:nsvd) * respSigresh1{j}(1:nsvd, 1:nsvd);
                    r1 = [zeros(k, nsvd); respRresh1{i}(1:nt - k, 1:nsvd)];
                    r2 = [zeros(l, nsvd); respRresh1{j}(1:nt - l, 1:nsvd)];
                    
                    respPass3 = respPass3 + sum(diag(r2' * r1 * l1' * l2));
                    resp3(indi, indj) = resp3(indi, indj) + respPass3;
                end
                indi = indi + 1;
            end
        end
        indj = indj + 1;
    end
end


respOtpt = cell(2, 2);

respOtpt{1, 1} = resp1;

respOtpt{1, 2} = resp2;

respOtpt{2, 1} = zeros(length(resp3), length(resp1));

respOtpt{2, 2} = resp3;
respOtpt = cell2mat(respOtpt);
