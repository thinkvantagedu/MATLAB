clear all; clc;

%%
% define filename
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
filename.new='C:\Temp\trimed_textfile.py';
filename.trim='C:\Temp\abaqusMacros_L9H2_dynamics_submission1.py';
% 'find seperation row'.
compare_row='mdb.jobs[''L9H2_dynamics''].submit(consistencyChecking=OFF)';
%%
% trim spaces in macros
delete(filename.new);
TrimString(filename.trim, filename.new);

%%
% import macros as char
filename=filename.new;
textfile_py=char(importdata(filename, 's'));

%%
% remove def row in macros
for i_rmv=1:length(textfile_py)
   if strncmpi(textfile_py(i_rmv,:), 'def ', 4)==1
      %identify line location of required text.
      line_node_rmv=i_rmv;
      break
   end
end
textfile_py(line_node_rmv, :)=[];
%%
% write without adding heading, only works with 'submisson' macros
delete('C:\Temp\connection.py');
fid=fopen('C:\Temp\connection.py','w');
for i_readpy1=(1:length(textfile_py))
    
    fprintf(fid, '%s\n', textfile_py(i_readpy1, :)); 
    
end
fclose(fid);
%%
% find seperation row
for i_text_1=1:length(textfile_py)
    % strncmpi compares the 1st n characters of 2 strings for equality
        % strncmpi(string,string,n) compares the 1st n characters.
    if strncmpi(textfile_py(i_text_1,:),...
            compare_row, size(compare_row, 2))==1
      %identify line location of required text.
      line_node_seperate=i_text_1;
      break
    end
end

%%
% define INP input and output
INPfilename='C:\Temp\L9H2_dynamics.inp';
FiletoBeInserted='C:\Temp\L9H2_dynamics.inp';
[cons]=ABAQUSReadINPCons(INPfilename);
[node, elem]=ABAQUSReadINPGeo(INPfilename);
%%
% import INP and find parameter location
[strtext]=DisplayText(INPfilename);
Strtofind='*Elastic';
[line_node]=FindTextRowNO(INPfilename, Strtofind);
elastic_parameter=str2num(strtext(line_node(1)+1, :));
% parameter in INP file has to be exactly the same as YoungsM!
YoungsM=elastic_parameter(:, 1);

%%
% NSnap=3;
snap_E=[5];
NSnap=length(snap_E);
% snap_E=(logspace(-1, 1.3, NSnap))';

% E to be inserted, change E in INP to FULL number (i.e. with all zeros)
test_E=[YoungsM; snap_E];
str_E0=num2str(test_E);
time=1;
t_step=0.001;
iteratives=time/t_step;
ABA_t=0:t_step:time;
%%
% extract geo info from INP.

node_no=node(size(node, 1), 1);
snap_storage=zeros(3*node_no, iteratives*NSnap);
delete('C:\Temp\abaqus.rpt');
for i_applied_E=1:NSnap
    %%
%     insert MTX output in INP file.
%     delete(INPfilename);
%     [Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, FiletoBeInserted);
    %%
    
    str_E=strtrim(str_E0(i_applied_E, :));
    if i_applied_E+1==length(test_E)+1
        break
    end
    str_E_1=strtrim(str_E0(i_applied_E+1, :));
    applied_E=strrep(strtext(line_node(1, :)+1, :), str_E, str_E_1);
    rep_str=strrep(strtext(line_node(1, :)+1, :), strtext(line_node(1, :)+1, :), applied_E);
    strtext_1=cellstr(strtext);
    strtext_1(line_node(1, :)+1, :)={rep_str};
    strtext=char(strtext_1);
    ExistingFilename=strtext;
%     create INP in disk
    [ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);


    system('abaqus cae noGUI=C:\Temp\connection.py');
    [result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
%     rearrange result data, import as num row by row.
%     delete the old report file if error happens here.
    selected_rows_str=result_data(size(result_data, 1)-iteratives+1:size(result_data, 1), :);

    %%
    % transform str rows to num rows.
    selected_rows_num=zeros(size(selected_rows_str, 1), 3*node_no+1);
    for i_resultdata=1:size(selected_rows_str, 1) 
        i_resultdata;
        selected_rows_str2num=str2num(selected_rows_str(i_resultdata, :));
        selected_rows_num(i_resultdata, :)=selected_rows_num(i_resultdata, :)+...
            selected_rows_str2num;       
    end 
    %%
    % rearrange nums to U1, U2, UR3 in column matrix. t=0 row IS NOT
    % INCLUDED!
    re_se_rows_num1=zeros(size(selected_rows_num, 1), size(selected_rows_num, 2)-1);
    % each 3 cols are node_no*0+i_rearrange+1:node_no*2+i_rearrange+1, i.e.
    % 31*0+2:31*2+2
    for i_rearrange=1:node_no   
        re_se_rows_num1(:, i_rearrange*3-2:i_rearrange*3)=...   
        re_se_rows_num1(:, i_rearrange*3-2:i_rearrange*3)+...      
        [selected_rows_num(:, node_no*0+i_rearrange+1), ...       
        selected_rows_num(:, node_no*1+i_rearrange+1), ...      
        selected_rows_num(:, node_no*2+i_rearrange+1)];
    end
    re_se_rows_num=re_se_rows_num1';
    %%
%     store result columns in snap_storage
    snap_storage(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))=...
        snap_storage(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))+...
        re_se_rows_num;
%     if i_applied_E=
end
%%
NPhi=19;
[X, Phi, Sigma]=SVD(snap_storage, NPhi);
% keyboard;
%%
% nodal force matrix, for applying different force at time steps.
% nodalforce.nf_nd=2;
% nodalforce.nd_force=-1;
% [nodal_force]=NodalForce(node, nodalforce);

% define force matrix in time. One array each time step. Force sign needs
% to be CORRECT, i.e. positive or negative.
f_node=2;
f_dof=3*f_node-1;
deltaT=0.001;
MaxT=1;
amp=sparse(3*length(node), MaxT/deltaT+1);
amp_t=(0:deltaT:1);

% ----------
% impulse force.
% t_imp1=1;
% t_imp2=1.5;
% t_imp3=2;
% t_imp4=2.5;
% amp_t1=t_imp1:deltaT:(t_imp2-deltaT);
% amp_t2=t_imp2:deltaT:(t_imp3-deltaT);
% amp_t3=t_imp3:deltaT:(t_imp4-deltaT);
% 
% amp_value1=-2*(amp_t1)+2;
% amp_value2=-1;
% amp_value3=2*(amp_t3)-5;
% 
% amp(5, (t_imp1/deltaT):(t_imp2/deltaT-1))=amp(5, (t_imp1/deltaT):(t_imp2/deltaT-1))+amp_value1;
% amp(5, (t_imp2/deltaT):(t_imp3/deltaT-1))=amp(5, (t_imp2/deltaT):(t_imp3/deltaT-1))+amp_value2;
% amp(5, (t_imp3/deltaT):(t_imp4/deltaT-1))=amp(5, (t_imp3/deltaT):(t_imp4/deltaT-1))+amp_value3;

% ----------

% sine force.
amp_value=-sin(pi/4*amp_t);
amp(f_dof, 1:length(amp_t))=amp(f_dof, 1:length(amp_t))+amp_value;

% ----------

% keyboard
%%
% extract and reduce matrices
MTX_M_file='C:\Temp\L9H2_dynamics-1_MASS1.mtx';
MTX_K_file='C:\Temp\L9H2_dynamics-1_STIF1.mtx';

[MTX_M_full]=ABAQUSReadMTX(MTX_M_file);
[MTX_K_full]=ABAQUSReadMTX(MTX_K_file);
[MTX_K_modi]=ABAQUSModifyMTXPenalty(MTX_K_full, cons, node);
MTX_C_full=zeros(size(MTX_M_full));

%%
% deleted the cols and rows correspond to boundary conditions.
MTX_M_free=ABAQUSDeleteBCinMTX(MTX_M_full, cons, node);
MTX_K_free=ABAQUSDeleteBCinMTX(MTX_K_full, cons, node);
MTX_C_free=ABAQUSDeleteBCinMTX(MTX_C_full, cons, node);
amp_free=ABAQUSDeleteBCRowsinMTX(amp, cons, node);
[U_ABA_free]=ABAQUSDeleteBCRowsinMTX(re_se_rows_num, cons, node);
Phi_free=ABAQUSDeleteBCRowsinMTX(Phi, cons, node);

%%
% test Newmark, use non-reduced matrices and identity matrix for Phi.
% amplitude corresponds to time step NO.
id_Phi=eye(size(MTX_M_free));
acce='average';
% modify amp iterative when modify deltaT and time_step_NO.

U0_testN=zeros(size(MTX_M_free, 1), 1);
V0_testN=zeros(size(MTX_M_free, 1), 1);
A0_testN=zeros(size(MTX_M_free, 1), 1);
% test Newmark without constraints.
[U_testN, V_testN, A_testN, U_full_testN, t_testN, t_step_NO]=NewmarkBetaReducedMethod...
    (id_Phi, MTX_M_free, MTX_C_free, MTX_K_free, amp_free, acce, deltaT, MaxT, U0_testN, V0_testN, A0_testN);

%%
% calculate the system frequency.
[eigve, eigva]=eigs(MTX_M_free, MTX_K_free, 10);
fre_sys=eigva^(1/2)/(2*pi); % cycle/s.
Periods = 2*pi*(diag(eigva).^(1/2));
%%
% error between Newmark and ABAQUS in 2nd norm in time.

err=zeros(size(U_testN, 2), 1);
for i_err=1:length(err)

    err(i_err)=err(i_err)+log10(norm(U_testN(:, i_err)-U_ABA_free(:, i_err)));
%     /norm(U_ABA_free(:, i_err)));

end
%%
% reduce matrices
M_r=Phi_free'*MTX_M_free*Phi_free;
K_r=Phi_free'*MTX_K_free*Phi_free;
C_r=zeros(size(M_r));
F_r=Phi_free'*amp_free;
acce='average'; 
% %%
% % Newmark Beta method with reduced matrices
% 
U0_r=Phi_free'*U0_testN;
V0_r=Phi_free'*V0_testN;
A0_r=Phi_free'*A0_testN;
[U_r, V_r, A_r, U, t, t_step_NO]=NewmarkBetaReducedMethod...
    (Phi_free, M_r, C_r, K_r, F_r, acce, deltaT, MaxT, U0_r, V0_r, A0_r);
%%
err_appr_ABA=zeros(size(U, 2), 1);
for i_errappraba=1:length(err_appr_ABA)

    err_appr_ABA(i_errappraba)=err_appr_ABA(i_errappraba)+...
        abs((norm(U(:, i_errappraba)-U_ABA_free(:, i_errappraba)))/norm(U_ABA_free(:, i_errappraba)));
    
%     /norm(U_ABA_free(:, i_err)));

end
%%
err_appr_newm=zeros(size(U, 2), 1);
for i_errapprnewm=1:length(err_appr_newm)

    err_appr_newm(i_errapprnewm)=err_appr_newm(i_errapprnewm)+...
        abs((norm(U(:, i_errapprnewm)-U_testN(:, i_errapprnewm)))/norm(U_testN(:, i_errapprnewm)));
    
%     /norm(U_ABA_free(:, i_err)));

end
%%
% plot force in time domain.
% figure(1);
% plot(t_testN, amp(f_dof, :));
% % title('');
% xlabel('time');
% ylabel('force');
%%
% plot Newmark approximation and ABAQUS result of node n, u2 in time domain.
% figure(2);
% plot(t_testN(1:(length(t_testN)-1)), U_testN(7, :), 'r-.',...
%     ABA_t(1:(length(ABA_t)-1)), U_ABA_free(7, :), 'b--');
% title('Node 3, displacement in x')
% legend('Newmark', 'ABAQUS');
% xlabel('time');
% ylabel('displacement');
%%
% compare rotation of node 2 of Newmark, ABAQUS and relative error in one
% plot
% figure(3);
% plot(t_testN(1:(length(t_testN)-1)), U_testN(5, :), 'r-.',...
%     ABA_t(1:(length(ABA_t)-1)), U_ABA_free(5, :), 'b--', ...
%     t_testN(1:(length(t_testN)-1)), err, 'k');
% title('Node 2, displacement in y and global normalized error in log10')
% legend('Newmark', 'ABAQUS', 'global normalized error');
% xlabel('time');
% ylabel('');
%%
% plot error
% figure(4);
% plot(t_testN(1:(length(t_testN)-1)), err, 'b')

%%
figure(6);
testdof=1;
plot(t_testN(1:(length(t_testN)-1)), U(testdof, :), 'r-.', ...
    t_testN(1:(length(t_testN)-1)), U_testN(testdof, :), 'b--', ...
    ABA_t(1:(length(ABA_t)-1)), U_ABA_free(testdof, :), 'k');
title('Node 12, rotation in z, reduce basis size=19')
legend('MOR Newmark result', 'Newmark result', 'ABAQUS result');
xlabel('time');
ylabel('displacement');

%%
% plot error between approximation and ABAQUS.
% figure(6);
% plot(t(1:(length(t)-1)), err_appr_ABA, 'b')
% title('Relative error between MOR and ABAQUS in 2nd norm')
% % legend('MOR Newmark result', 'Newmark result', 'ABAQUS result');
% xlabel('time');
% ylabel('relative error');
%%
% plot error between approximation and ABAQUS.
% figure(7);
% plot(t(1:(length(t)-1)), err_appr_newm, 'b')
% title('Relative error between MOR and Newmark in 2nd norm')
% % legend('MOR Newmark result', 'Newmark result', 'ABAQUS result');
% xlabel('time');
% ylabel('relative error');
%%
% plot basis of U_r.
% figure(7);
% plot(t_testN(1:(length(t_testN)-1)), U_r(1, :), 'r:', ...
%     t_testN(1:(length(t_testN)-1)), 10*U_r(2, :), 'c-+', ...
%     t_testN(1:(length(t_testN)-1)), 10*U_r(3, :), 'b-.', ...
%     t_testN(1:(length(t_testN)-1)), 10*U_r(4, :), 'k:', ...
%     t_testN(1:(length(t_testN)-1)), 10*U_r(5, :), 'm--');
% legend('1', '2', '3', '4', '5');
% title('Node 3, displacement in x')
% legend('Newmark', 'ABAQUS');
% xlabel('time');
% ylabel('displacement');
%%
% % [depl,vel,accl,U,t] = NewmarkMethod(M_r,K_r,C_r,F_r,Phi,sdof, acceleration);
% err=zeros(size(re_se_rows_num, 2), 1);
% % U_testN1=U_testN(:, 11:10:2002);
% for i_err=1:size(re_se_rows_num, 2)
% 
%     err(i_err, :)=err(i_err, :)+norm(U_testN(:, i_err+1)-re_se_rows_num(:, i_err))/norm(re_se_rows_num(:, i_err));
% 
% end

