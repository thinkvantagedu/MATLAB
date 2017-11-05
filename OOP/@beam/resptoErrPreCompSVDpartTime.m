function obj = resptoErrPreCompSVDpartTime(obj)
% extract from each interpolation sample point to obtain affined error
% matrices, using SVD vectors. The more SVD vectors used, the closer to
% results from method resptoErrPreCompNoSVDpartTime. 

obj.err.pre.hhat = cell(obj.no.pre.hhat, 2);
nshift = obj.no.t_step - 2;
ntotal = obj.no.rb * obj.no.phy * 2;

for iPre = 1:obj.no.pre.hhat
    %%
    obj.err.pre.hhat(iPre, 1) = {iPre};
    
    % process force response.
    respFce = obj.resp.storeFce.hhat{iPre};
    [respFceL, respFceSig, respFceR] = svd(respFce, 'econ');
    
    % process pm responses, only store the essential information.
    respPmPass = obj.resp.storePm.hhat(iPre, :, :, :);
    respPmPass = cellfun(@(v) -v, respPmPass, 'un', 0);
    [respPmL, respPmSig, respPmR] = cellfun(@(v) svd(v, 'econ'), ...
        respPmPass, 'un', 0);
    % combine force responses with pm responses.
    respLresh = [{respFceL}; reshape(respPmL, [ntotal, 1])];
    respSigresh = [{respFceSig}; reshape(respPmSig, [ntotal, 1])];
    respRresh = [{respFceR}; reshape(respPmR, [ntotal, 1])];
    
    % dump the unwanted svd vectors.
    respLresh = cellfun(@(v) v(:, 1:obj.no.respSVD), respLresh, 'un', 0);
    respSigresh = cellfun(@(v) v(1:obj.no.respSVD, 1:obj.no.respSVD), ...
        respSigresh, 'un', 0);
    respRresh = cellfun(@(v) v(:, 1:obj.no.respSVD), respRresh, 'un', 0);
    
    % multiply SVD L vectors with singular values.
    respLresh = cellfun(@(v, w) v * w, respLresh, respSigresh, 'un', 0);

    nbaseInit = obj.no.rb * obj.no.phy + 1;
    nbase = obj.no.rb * obj.no.phy * 2 + 1;
    nall = obj.no.rb * obj.no.phy * obj.no.t_step + 1;
    
    %% ete part 1.
    resp1 = zeros(nbase);
    for i = 1:nbase
        for j = i : nbase
            respPass1 = 0;
            
            l1 = respLresh{i};
            l2 = respLresh{j};
            r1 = respRresh{i};
            r2 = respRresh{j};
            
            respPass1 = respPass1 + trace(r2' * r1 * l1' * l2);
            resp1(i, j) = resp1(i, j) + respPass1;
        end
    end
    %% ete part 2.
    resp2 = zeros(nbase, nall - nbase);
    r2 = zeros(obj.no.t_step, 1);
    for i = 1:nbase
        ind = 1;
        for j = 1:nshift
            for l = (nbaseInit + 1):nbase
                respPass2 = 0;
                
                l1 = respLresh{i};
                l2 = respLresh{l};
                r1 = respRresh{i};
                seg = respRresh{l}(1:obj.no.t_step - j, :);
                r2(end - length(seg) + 1 : end) = ...
                    r2(end - length(seg) + 1 : end) + seg;
                respPass2 = respPass2 + trace(r2' * r1 * l1' * l2);
                resp2(i, ind) = resp2(i, ind) + respPass2;
                ind = ind + 1;
                
            end
        end
        
    end
    %% ete part 3.
    resp3 = zeros(nall - nbase);
    indj = 1;
    r1 = zeros(obj.no.t_step, 1);
    r2 = zeros(obj.no.t_step, 1);
    for l = 1:nshift
        for j = (nbaseInit + 1):nbase
            indi = 1;
            for k = 1:nshift
                for i = (nbaseInit + 1):nbase
                    respPass3 = 0;
                    if indi <= indj
                        l1 = respLresh{i};
                        l2 = respLresh{j};
                        seg1 = respRresh{i}(1:obj.no.t_step - k, :);
                        seg2 = respRresh{j}(1:obj.no.t_step - l, :);
                        r1(end - length(seg1) + 1 : end) = ...
                            r2(end - length(seg1) + 1 : end) + seg1;
                        r2(end - length(seg2) + 1 : end) = ...
                            r2(end - length(seg2) + 1 : end) + seg2;
                        rprod = r2' * r1 * l1' * l2;
                        respPass3 = respPass3 + trace(rprod);
                        resp3(indi, indj) = resp3(indi, indj) + respPass3;
                    end
                    indi = indi + 1;
                end
            end
            indj = indj + 1;
        end
    end
    
    %%
    respTrans = cell(2, 2);
    respTrans{1, 1} = resp1;
    
    respTrans{1, 2} = resp2;
    
    respTrans{2, 1} = zeros(length(resp3), length(resp1));
    
    respTrans{2, 2} = resp3;
    
    respTrans = cell2mat(respTrans);
    
    obj.err.pre.hhat(iPre, 2) = {sparse(respTrans)};
    
end

obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);