clear variables; clc;
pm0.rb1 = [1 4 3 2; 2 9 8 6; 6 7 8 9];
pm1.rb1 = [1 2 3 4; 4 5 6 7; 7 8 9 1];
pm1.rb2 = [3 2 1 1; 6 5 4 5; 4 3 2 1];
pm1.rb3 = [1 4 3 2; 2 4 1 2; 1 2 3 2];
pm2.rb1 = [2 3 4 5; 5 6 7 8; 9 8 7 6];
pm2.rb2 = [4 3 2 1; 7 6 5 4; 6 5 4 3];
pm2.rb3 = [2 8 7 6; 9 5 3 2; 8 9 7 6];
pm3.rb1 = [3 4 5 6; 6 7 8 9; 2 3 4 5];
pm3.rb2 = [5 4 3 2; 8 7 6 5; 8 7 9 8];
pm3.rb3 = [5 6 7 8; 6 5 8 7; 8 5 4 3];
pm4.rb1 = [4 5 6 7; 7 8 9 8; 4 7 5 6];
pm4.rb2 = [6 5 4 3; 9 8 7 6; 7 6 9 8];
pm4.rb3 = [1 2 3 4; 2 9 5 6; 1 4 6 7];
no.t_step = size(pm1.rb1, 2);
no.dof = size(pm1.rb1, 1);
no.rb = 3;
no.pm = 4;
z.val = [pm1.rb1 pm1.rb2 pm1.rb3; pm2.rb1 pm2.rb2 pm2.rb3; ...
    pm3.rb1 pm3.rb2 pm3.rb3; pm4.rb1 pm4.rb2 pm4.rb3];

xy = [1 1; 1 2; 2 1; 2 2];
%% interpolate, sum, sumsqr.
[coeff.val] = LagInterpolationCoeff(xy, z.val);

range.x = (1:0.1:2);
range.y = (1:0.1:2);
no.range = length(range.x);
range.forthsm = zeros(no.range, no.range);
alpha.val = [1 3 5 7; 2 4 6 8; 7 8 9 1];

for i_range = 1:no.range
    for j_range = 1:no.range
        
        otpt.x = range.x(i_range);
        otpt.y = range.y(j_range);
        
        otpt.val = LagInterpolationOtptSingle(coeff.val, otpt.x, otpt.y, 4);
        
        otpt.cel = mat2cell(otpt.val, no.dof, no.t_step*ones(1, no.rb));
        otpt.asemb = zeros(no.dof, no.t_step);
        % i_ts denotes time.
        for i_ts = 1:no.t_step
            % i_rb denotes rb.
            for i_rb = 1:no.rb
                otpt.sgle_cel = otpt.cel(i_rb);
                otpt.zeros = zeros(no.dof, i_ts-1);
                otpt.nonzeros = otpt.sgle_cel{:}(:, 1:no.t_step-i_ts+1);
                otpt.all = [otpt.zeros otpt.nonzeros]*alpha.val(i_rb, i_ts);
                otpt.asemb = otpt.asemb+otpt.all;
                
            end
        end
        
        otpt.sq = sumsqr(pm0.rb1-otpt.asemb);
        range.forthsm(i_range, j_range) = range.forthsm(i_range, j_range)+otpt.sq;
        
    end
end

%% interpolate, realign, transpose, multiply, sum.

z.cel = mat2cell(z.val, no.dof*ones(1, no.pm), no.t_step*ones(1, no.rb));
% resp.cel.all is no.t_step*no.rb space-time solutions in no.pm in 3rd DIM.
resp.cel.all = cell(no.t_step, no.rb, no.pm);
% pm
for i_pm = 1:no.pm
    % rb
    for i_rb = 1:no.rb
        % time_step
        for i_ts = 1:no.t_step
            resp.zeros = zeros(no.dof, i_ts-1);
            resp.tmp = z.cel(i_pm, i_rb);
            resp.nonzeros = resp.tmp{:}(:, 1:no.t_step-i_ts+1);
            resp.all = {[resp.zeros resp.nonzeros]};
            resp.cel.all(i_ts, i_rb, i_pm) = resp.all;
            
        end
        
    end
    
end


resp.pm.all.trans = cell(no.pm, 1);
for i_pm = 1:no.pm
    
    resp.pm.sgle = resp.cel.all(:, :, i_pm);
    resp.pm.col_asemb = zeros(no.dof*no.t_step, numel(resp.pm.sgle));
    for i_resh = 1:numel(resp.pm.sgle)
        % transfer into space and time solutions.
        resp.pm.col = resp.pm.sgle{i_resh}(:);
        resp.pm.col_asemb(:, i_resh) = resp.pm.col_asemb(:, i_resh)+resp.pm.col;
        
    end
    resp.pm.col_asemb = [pm0.rb1(:) -resp.pm.col_asemb];
    resp.pm.trans = resp.pm.col_asemb'*resp.pm.col_asemb;
    
    % store (no.t_step*no.rb)^2 scalars for no.pm times, from top to
    % bottom.
    resp.pm.all.trans(i_pm) = {resp.pm.trans};
    
end
alpha.col = alpha.val';
alpha.col = [1; alpha.col(:)];
alpha.trans = alpha.col*alpha.col';
[resp.coeff.val] = LagInterpolationCoeff(xy, cell2mat(resp.pm.all.trans));
resp.onsm = zeros(no.range, no.range);
for i_range = 1:no.range
    for j_range = 1:no.range
        
        otpt.x = range.x(i_range);
        otpt.y = range.y(j_range);
        
        resp.otpt.val = LagInterpolationOtptSingle(resp.coeff.val, otpt.x, otpt.y, 4);
        resp.sq = resp.otpt.val.*alpha.trans;
        resp.sm = sum(resp.sq(:));
        resp.onsm(i_range, j_range) = resp.onsm(i_range, j_range)+resp.sm;
        
    end
    
end

error = abs((range.forthsm-resp.onsm)./range.forthsm);
%%
figure(1)
surf(range.x, range.y, range.forthsm);

figure(2)
surf(range.x, range.y, resp.onsm);

figure(3)
surf(range.x, range.y, error);











