clear variables; clc;

% Phi=eye(2);
% K_r=[6 -2; -2 4];
% M_r=[2 0; 0 1];
% C_r=[0 0; 0 0];
% 
% F_r=zeros(2, 16);
% for i_f0=1:length(F_r)
%     F_r(:, i_f0)=F_r(:, i_f0)+[0; 10];
% end
% F_var = (1:100000);
% 
% dT=0.28;
% maxT=4.2;
% U0=[0; 0];
% V0=[0; 0];
% acce='average';
% 
% F_r1 = F_r(1, :);
% F_r2 = F_r(2, :);
% 
% nm_all = zeros(1000000, 1);
% 
% 
% 
% parfor i = 1:length(F_var)
%     
%     F_0 = F_r;
%     
%     F = F_r2;
%     
%     F_inpt = F(:, 1) + F_var(i);
%     
%     F_0(2, 1) = F_inpt;
%         
% %     [U_r, ~, ~, ~, ~, ~, ~, ~] = arrayfun(@NewmarkBetaReducedMethod, ...
% %         Phi, M_r, C_r, K_r, F_inpt, acce, dT, maxT, U0, V0);
%     
%     [U_r, ~, ~, ~, ~, ~, ~, ~] = NewmarkBetaReducedMethod...
%         (Phi, M_r, C_r, K_r, F_0, acce, dT, maxT, U0, V0);
%     
%     nm = norm(U_r);
%     
%     nm_all(i) = nm_all(i) + nm;
%     
% end

% inpt = rand(5);
% 
% temp = zeros(5);
% parfor i = 1:10000
%
%     otpt = sin(inpt);
%     if i == 10000
%         temp = temp + otpt;
%     end
% end

inpt.a1 = rand(100);

inpt.a2 = rand(100);

parfor i = 1:10000
    
    inpt_pass = inpt.a1;
    otpt = sin(inpt_pass.a1);
    
end

























