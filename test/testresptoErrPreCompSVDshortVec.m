% test a scaled model for method resptoErrPreCompSVDshortVec.

clear; clc;

nd = 4;
nrb = 1;
nphy = 2;
nt = 3;
nf = 1;
nsvd = 3;
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
fcell = cell(1, nsvd);
for i = 1:nsvd
    
    x = respFceL(:, i) * respFceSig(i, i);
    y = respFceR(:, i);
    fcell{i} = {x; y};
    
end
uf = reshape(uf, [nd * nt, 1]);
% process pm.

respPmSpaceTime = cellfun(@(v) reshape(v, [nd, nt]), respPmPass, ...
    'UniformOutput', false);

[respPmL, respPmSig, respPmR] = cellfun(@(v) svd(v, 'econ'), ...
    respPmSpaceTime, 'UniformOutput', false);

respPmCell = cell(1, nrb, nphy, nt + 1, nsvd);

for i = 1: nrb
    for j = 1:nphy
        for k = 1:nt + 1
            for l = 1:nsvd
                
                x = respPmL{1, i, j, k}(:, l) * respPmSig{1, i, j, k}(l, l);
                y = respPmR{1, i, j, k}(:, l);
                respPmCell{1, i, j, k, l} = {x; y};
                
            end
        end
    end
end

respTrans = zeros(nrb * nphy * (nt + 1) + 1);

respPmResh = reshape(respPmCell, [nrb * nphy * (nt + 1), nsvd]);

respAll = [fcell; respPmResh];

for i = 1:nrb * nphy * (nt + 1) + nf
    for j = 1:nrb * nphy * (nt + 1) + nf
        respPass = 0;
        l1st = zeros(nd, nsvd);
        l2st = zeros(nd, nsvd);
        r1st = zeros(nt, nsvd);
        r2st = zeros(nt, nsvd);
        for k = 1:nsvd
            
            L1 = respAll{i, k}{1};
            L2 = respAll{j, k}{1};
            R1 = respAll{i, k}{2};
            R2 = respAll{j, k}{2};
            l1st(:, k) = L1;
            l2st(:, k) = L2;
            r1st(:, k) = R1;
            r2st(:, k) = R2;
        end
        respPass = respPass + sum(diag(r2st' * r1st * l1st' * l2st));
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

respPmCell1 = cell(1, nrb, nphy, 2, nsvd);

for i = 1:nrb
    for j = 1:nphy
        for k = 1:2
            for l = 1:nsvd
                
                x1 = respPmL1{1, i, j, k}(:, l) * respPmSig1{1, i, j, k}(l, l);
                y1 = respPmR1{1, i, j, k}(:, l);
                respPmCell1{1, i, j, k, l} = {x1; y1};
                
            end
        end
    end
end


respPmResh1 = reshape(respPmCell1, [nrb * nphy * 2, nsvd]);

respAll1 = [fcell; respPmResh1];

nbase = nrb * nphy * 2 + 1;
nall = nrb * nphy * (nt + 1) + 1;


resp1 = zeros(nbase);
for i = 1:nbase
    for j = i:nbase
        respPass1 = 0;
        l1st = [];
        l2st = [];
        r1st = [];
        r2st = [];
        for k = 1:nsvd
            
            L1 = respAll1{i, k}{1};
            L2 = respAll1{j, k}{1};
            R1 = respAll1{i, k}{2};
            R2 = respAll1{j, k}{2};
            
            l1st = [l1st L1];
            l2st = [l2st L2];
            r1st = [r1st R1];
            r2st = [r2st R2];
        end
        respPass1 = respPass1 + sum(diag(r2st' * r1st * l1st' * l2st));
        resp1(i, j) = resp1(i, j) + respPass1;
    end
end

resp2 = zeros(nbase, nall - nbase);
for i = 1:nbase
    ind = 1;
    for j = 1:nshift
        for l = (nall - nbase):nbase
            
            respPass2 = 0;
            l1st = [];
            l2st = [];
            r1st = [];
            r2st = [];
            for k = 1:nsvd
                L1 = respAll1{i, k}{1};
                L2 = respAll1{l, k}{1};
                R1 = respAll1{i, k}{2};
                R2 = [zeros(j, 1); respAll1{l, k}{2}(1:nt - j)];
                l1st = [l1st L1];
                l2st = [l2st L2];
                r1st = [r1st R1];
                r2st = [r2st R2];
            end
            respPass2 = respPass2 + sum(diag(r2st' * r1st * l1st' * l2st));
            resp2(i, ind) = resp2(i, ind) + respPass2;
            ind = ind + 1;
            
        end
        
    end
end

resp3 = zeros(nall - nbase);
indj = 1;
for l = 1:nshift
    for j = 4:nbase
        indi = 1;
        for k = 1:nshift
            for i = 4:nbase
                respPass3 = 0;
                
                if indi <= indj
                    l1st = [];
                    l2st = [];
                    r1st = [];
                    r2st = [];
                    for h = 1:nsvd
                        L1 = respAll1{i, h}{1};
                        L2 = respAll1{j, h}{1};
                        R1 = [zeros(k, 1); respAll1{i, h}{2}(1:nt - k)];
                        R2 = [zeros(l, 1); respAll1{j, h}{2}(1:nt - l)];
                        l1st = [l1st L1];
                        l2st = [l2st L2];
                        r1st = [r1st R1];
                        r2st = [r2st R2];
                        
                    end
                    respPass3 = respPass3 + sum(diag(r2st' * r1st * l1st' * l2st));
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

relatErr = norm((ete - respOtpt), 'fro') / norm(ete, 'fro');






















