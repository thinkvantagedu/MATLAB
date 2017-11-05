function obj = resptoErrPreCompSVDpartTimeImprovised(obj)

% extract from each interpolation sample point to obtain affined error
% matrices, then assemble them into a (no.pre.hhat * 1)
% cell according to number of sample points.
% CT = contain time. Real time (no.t_step), not initial and step-in (2).
% only saves upper right triangular matrices.

obj.err.pre.hhat = cell(obj.no.pre.hhat, 2);
% the number of vectors being shifted. 
nshift = obj.no.rb * obj.no.phy;
ntotal = nshift * 2 + 1;

for iPre = 1:obj.no.pre.hhat
    
    obj.err.pre.hhat(iPre, 1) = {iPre};
    % extract respPreStore from interpolation samples, each cell contains
    % left and right vectors. Dimension order is iPre, nrb, nphy, 2.
    % already change sign for respPreStore in function respImpPartTimeSVD.
    respPreStore = obj.resp.storePm.hhat(iPre, :, :, :);
    respPreStore = permute(respPreStore, [1 3 4 2]);
    % reshape respPreTemp in one dimension.
    respPreTemp = reshape(respPreStore, obj.no.rb * obj.no.phy * 2, 1);
    
    % CT, add the response from force.
    respPreStore = [obj.resp.storeFce.hhat(iPre); respPreTemp];
    
    % separate left vectors and right vectors, release the cells to
    % doubles.
    
    respPmL = cellfun(@(v) v(1, :), respPreStore, 'un', 0);
    respPmL = cellfun(@(v) cell2mat(v), respPmL, 'un', 0);
    respPmR = cellfun(@(v) v(2, :), respPreStore, 'un', 0);
    respPmR = cellfun(@(v) cell2mat(v), respPmR, 'un', 0);
    
    % select the shifted left and right vectors. 
    respPmLspec = respPmL(ntotal - nshift + 1:end);
    respPmRspec = respPmR(ntotal - nshift + 1:end);
    
    %%
    errBlkMain = cell(obj.no.t_step - 1);
    for iBlk = 1:length(errBlkMain)
        for jBlk = 1:length(errBlkMain)
            
            if iBlk == 1 && jBlk == 1 % level 1, element 1
                
                respPmLk = sparse(ntotal, ntotal);
                for i = 1:ntotal
                    for j = i:ntotal
                        respPmLk(i, j) = respPmLk(i, j) + ...
                            trace(respPmR{j}' * respPmR{i} * ...
                            respPmL{i}' * respPmL{j});
                    end
                end
                errBlkMain(iBlk, jBlk) = {respPmLk};
                
            elseif iBlk == 1 && jBlk ~= 1 % level 1, element n
                
                respPmLk = sparse(ntotal, nshift);
                nshift2 = jBlk - 1;
                respPmRspec2 = cellfun(@(v) [sparse(nshift2, obj.no.respSVD); ...
                    v(1:obj.no.t_step - nshift2, :)], respPmRspec, 'un', 0);
                for i = 1:ntotal
                    for j = 1:nshift
                        respPmLk(i, j) = respPmLk(i, j) + ...
                            trace(respPmRspec2{j}' * respPmR{i} * ...
                            respPmL{i}' * respPmLspec{j});
                    end
                end
                errBlkMain(iBlk, jBlk) = {respPmLk};
                errBlkMain(jBlk, iBlk) = {sparse(ntotal, nshift)'};
                
            elseif iBlk ~= 1 && iBlk <= jBlk % level m, element n
                
                respPmLk = sparse(nshift, nshift);
                nshift1 = iBlk - 1;
                nshift2 = jBlk - 1;
                respPmRspec1 = cellfun(@(v) [sparse(nshift1, obj.no.respSVD); ...
                    v(1:obj.no.t_step - nshift1, :)], respPmRspec, 'un', 0);
                respPmRspec2 = cellfun(@(v) [sparse(nshift2, obj.no.respSVD); ...
                    v(1:obj.no.t_step - nshift2, :)], respPmRspec, 'un', 0);
                for i = 1:nshift
                    if iBlk == jBlk
                        jpass = i;
                    else
                        jpass = 1;
                    end
                    for j = jpass:nshift
                        respPmLk(i, j) = respPmLk(i, j) + ...
                            trace(respPmRspec2{j}' * respPmRspec1{i} * ...
                            respPmLspec{i}' * respPmLspec{j});
                    end
                end
                errBlkMain(iBlk, jBlk) = {respPmLk};
                if iBlk ~= jBlk
                    errBlkMain(jBlk, iBlk) = {sparse(nshift, nshift)'};
                end
                
            end
        end
    end
    
    errBlkMain = cell2mat(errBlkMain);
    errBlkMain = triu(errBlkMain);
    
    obj.err.pre.hhat(iPre, 2) = {errBlkMain};
    
end

obj.err.pre.hat = obj.err.pre.hhat(1:obj.no.pre.hat, :);