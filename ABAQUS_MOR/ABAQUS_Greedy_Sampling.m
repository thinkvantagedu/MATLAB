clear all; clc;
%%
% variables:

% para_dist: distance between parameter name row and parameter value row.
% ABA_t: distrized time domain in ABAQUS.
% snap_init_store: initial storage of snapshot.
% amp: amplitude of force.



%%
addpath('C:\Temp\MATLAB');
addpath('C:\Temp\MATLAB\ABAQUS_MOR');
filename.new='C:\Temp\trimed_textfile_gre.py';
filename.trim='C:\Temp\abaqusMacros_L9H2_dynamics.py';

%%
% trim spaces in macros
delete(filename.new);
TrimString(filename.trim, filename.new);

%%
% read macros into MATLAB as char
filename=filename.new;
textfile_py=char(importdata(filename, 's'));

%%
% remove 'def' row in macros
str_rmv='def';
textfile_origin=textfile_py;
[textfile]=RemoveOneStringRowinText(textfile_origin, str_rmv);

%%
% write text into file
ConnectionFile='C:\Temp\connection_gre.py';
WrittenFile=textfile;
delete(ConnectionFile);
[WrittenFile]=WriteTextIntoDisk(WrittenFile, ConnectionFile);

%%
% define INP input and output
INPfilename='C:\Temp\L9H2_dynamics.inp';
FiletoBeInserted='C:\Temp\L9H2_dynamics.inp';
[Inserted_INP]=ABAQUSInsertIntoINP(INPfilename, FiletoBeInserted);
[cons]=ABAQUSReadINPCons(INPfilename);
[node, elem]=ABAQUSReadINPGeo(INPfilename);
node_no=node(size(node, 1), 1);

%%
% import INP.
[strtext]=DisplayText(INPfilename);
% define distance between '*Material, name=Material-I' and parameter.
para_dist=4;
% find parameter location I.
Strtofind.I='*Material, name=Material-I';
[line_node.I]=FindTextRowNO(INPfilename, Strtofind.I);
elastic_parameter.I=str2num(strtext(line_node.I(1)+para_dist, :));
% parameter in INP file has to be exactly the same as YoungsM!
YoungsM.I=elastic_parameter.I(:, 1);

% find parameter location S.
Strtofind.S='*Material, name=Material-S';
[line_node.S]=FindTextRowNO(INPfilename, Strtofind.S);
elastic_parameter.S=str2num(strtext(line_node.S(1)+para_dist, :));
% parameter in INP file has to be exactly the same as YoungsM!
YoungsM.S=elastic_parameter.S(:, 1);

%%
% form parameter domain (2D).
domainLength.I=20;
domainLength.S=20;
parameter.I=logspace(-2, 2, domainLength.I);
parameter.S=logspace(-1, 1, domainLength.S);
% combvec gives all combinations of vectors.
parameter.comb=combvec(parameter.I, parameter.S);
parameter.comb=parameter.comb';
%%
% define trial point.
trial_NO=5;
if trial_NO>domainLength.I||trial_NO>domainLength.S
    error('trial point exceeds parameter domain.')
end
parameter_trial.I=parameter.I(trial_NO);
parameter_trial.S=parameter.S(trial_NO);
Insert_E.I=[YoungsM.I; parameter_trial.I];
Insert_E.S=[YoungsM.S; parameter_trial.S];
str_E0.I=num2str(Insert_E.I);
str_E0.S=num2str(Insert_E.S);

%%
% compute first solution.
time=10;
t_step=0.01;
iteratives=time/t_step;
ABA_t=0:t_step:time;
snap_init_store=zeros(3*node_no, iteratives*1);

%%
for i_applied_E=1:1
    %%
%     modify parameter I.
    str_E.I=strtrim(str_E0.I(i_applied_E, :));
    if i_applied_E+1==length(Insert_E.I)+1 
        break
    end    
    str_E_1.I=strtrim(str_E0.I(i_applied_E+1, :));
    applied_E.I=strrep(strtext(line_node.I(1, :)+para_dist, :), str_E.I, str_E_1.I);
    rep_str.I=strrep(strtext(line_node.I(1, :)+para_dist, :), strtext(line_node.I(1, :)+para_dist, :), applied_E.I);
    strtext_1=cellstr(strtext);
    strtext_1(line_node.I(1, :)+para_dist, :)={rep_str.I};
%     modify parameter S.
    str_E.S=strtrim(str_E0.S(i_applied_E, :));
    if i_applied_E+1==length(Insert_E.S)+1 
        break
    end    
    str_E_1.S=strtrim(str_E0.S(i_applied_E+1, :));
    applied_E.S=strrep(strtext(line_node.S(1, :)+para_dist, :), str_E.S, str_E_1.S);
    rep_str.S=strrep(strtext(line_node.S(1, :)+para_dist, :), strtext(line_node.S(1, :)+para_dist, :), applied_E.S);
    strtext_1(line_node.S(1, :)+para_dist, :)={rep_str.S};
%     finalise the INP file.
    strtext=char(strtext_1);
    ExistingFilename=strtext;
%     create INP in disk.
    delete('C:\Temp\abaqus.rpt');
    [ExistingFilename]=WriteTextIntoDisk(ExistingFilename, FiletoBeInserted);
    system('abaqus cae noGUI=C:\Temp\connection_gre.py');
    [result_data]=char(importdata('C:\Temp\abaqus.rpt', 's'));
    %     rearrange result data, import as num row by row.
%     delete the old report file if error happens here.
    %%
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
    snap_init_store(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))=...
        snap_init_store(:, (i_applied_E*iteratives-iteratives+1):(i_applied_E*iteratives))+...
        re_se_rows_num;

end
Cleared_INPfilename='C:\Temp\L9H2_dynamics.inp';
[Cleared_INP]=ABAQUSClearFromINP(Cleared_INPfilename, INPfilename);

%%
% create initial snapshot.
NPhi=10;
[X, Phi.init, Sigma]=SVD(snap_init_store, NPhi);
Phi.init_free=ABAQUSDeleteBCRowsinMTX(Phi.init, cons, node);

%%
% generate parameterised basic matrices, such as 01 K and M.
MTX_file_M.I0S1='C:\Temp\L9H2_dynamics_matrices_I0S1_MASS1.mtx';
MTX_file_K.I0S1='C:\Temp\L9H2_dynamics_matrices_I0S1_STIF1.mtx';
MTX_file_M.I1S0='C:\Temp\L9H2_dynamics_matrices_I1S0_MASS1.mtx';
MTX_file_K.I1S0='C:\Temp\L9H2_dynamics_matrices_I1S0_STIF1.mtx';
[MTX_M.I0S1]=ABAQUSReadMTX(MTX_file_M.I0S1);
[MTX_K.I0S1]=ABAQUSReadMTX(MTX_file_K.I0S1);
[MTX_M.I1S0]=ABAQUSReadMTX(MTX_file_M.I1S0);
[MTX_K.I1S0]=ABAQUSReadMTX(MTX_file_K.I1S0);
MTX_M_free.I0S1=ABAQUSDeleteBCinMTX(MTX_M.I0S1, cons, node);
MTX_K_free.I0S1=ABAQUSDeleteBCinMTX(MTX_K.I0S1, cons, node);
MTX_M_free.I1S0=ABAQUSDeleteBCinMTX(MTX_M.I1S0, cons, node);
MTX_K_free.I1S0=ABAQUSDeleteBCinMTX(MTX_K.I1S0, cons, node);

% project MTX_I0S1 and MTX_I1S0 using Phi_init_free.
MTX_M_free_R.I0S1=Phi.init_free'*MTX_M_free.I0S1*Phi.init_free;
MTX_K_free_R.I0S1=Phi.init_free'*MTX_K_free.I0S1*Phi.init_free;
MTX_M_free_R.I1S0=Phi.init_free'*MTX_M_free.I1S0*Phi.init_free;
MTX_K_free_R.I1S0=Phi.init_free'*MTX_K_free.I1S0*Phi.init_free;

%%
% define nodal force matrix.
f_node=2;
f_dof=3*f_node-1;
deltaT=0.01;
MaxT=10;
force_t=4;
f_amp=sparse(3*length(node), MaxT/deltaT+1);
f_amp_t=(0:deltaT:force_t);

%%
% half sine force.
f_amp_value=-sin(pi/4*f_amp_t);
f_amp(f_dof, 1:length(f_amp_t))=f_amp(f_dof, 1:length(f_amp_t))+f_amp_value;
f_amp_free=ABAQUSDeleteBCRowsinMTX(f_amp, cons, node);
f_amp_free_R=Phi.init_free'*f_amp_free;








%%
% =========================================================================
%%
% extract initial matrices.
MTX_file_init.M='C:\Temp\L9H2_dynamics-1_MASS1.mtx';
MTX_file_init.K='C:\Temp\L9H2_dynamics-1_STIF1.mtx';
[MTX_init.M]=ABAQUSReadMTX(MTX_file_init.M);
[MTX_init.K]=ABAQUSReadMTX(MTX_file_init.K);
MTX_init_free.M=ABAQUSDeleteBCinMTX(MTX_init.M, cons, node);
MTX_init_free.K=ABAQUSDeleteBCinMTX(MTX_init.K, cons, node);
MTX_init_free.C=zeros(length(MTX_init_free.M));
id_phi=eye(length(MTX_init_free.M));
%%
acce='average';
err_store=zeros(length(parameter.I), length(parameter.S));
%%
al=1/4; delta=1/2;
a0=1/(al*deltaT^2);
a1=delta/(al*deltaT);
a2=1/(al*deltaT);
a3=1/(2*al)-1;
a4=delta/al-1;
a5=deltaT/2*(delta/al-2);
a6=deltaT*(1-delta);
a7=delta*deltaT;
MTX_hat=MTX_init_free.K+a0*MTX_init_free.M+a1*MTX_init_free.C;
inv_MTX_hat=inv(MTX_hat);
%%
% main loop.
tic

for i_sam=1:size(parameter.comb, 1)
   
    % invoke Newmark algorithm to compute the reduced system.

    % first sample point:
    M_sam_R=MTX_M_free_R.I1S0*parameter.comb(i_sam, 1)+MTX_M_free_R.I0S1*parameter.comb(i_sam, 2);
    K_sam_R=MTX_K_free_R.I1S0*parameter.comb(i_sam, 1)+MTX_K_free_R.I0S1*parameter.comb(i_sam, 2);
    C_sam_R=zeros(length(M_sam_R));

    U0_sam_R=zeros(size(M_sam_R, 1), 1);
    V0_sam_R=zeros(size(M_sam_R, 1), 1);
    A0_sam_R=zeros(size(M_sam_R, 1), 1);
    
    [U_sam_R, V_sam_R, A_sam_R, U_sam, V_sam, A_sam, t_sam, time_step_NO_sam]=NewmarkBetaReducedMethod...
        (Phi.init_free, M_sam_R, C_sam_R, K_sam_R, f_amp_free_R, acce, deltaT, MaxT, U0_sam_R, V0_sam_R, A0_sam_R);
    
    %%
    % compute the first residual.
    Res_FR=M_sam_R*Phi.init_free*A_sam_R-K_sam_R*Phi.init_free*U_sam_R; 
    Res=f_amp_free(:, 1:1000)-Res_FR;



    %%
    
    % from residual to equavilent displacement, use original matrices.
%     [U_err_R, V_err_R, A_err_R, U_err, V_err, A_err, t_err, time_step_NO_err]=NewmarkBetaReducedMethod...
%        (id_phi, MTX_init_free.M, MTX_init_free.C, MTX_init_free.K, Res, acce, deltaT, 9.99, U0_sam, V0_sam, A0_sam);
    
    %%
    % from residual to equavilent displacement, use fixed inv_MTX.
    [U_err_R1, V_err_R1, A_err_R1, U_err, V_err, A_err, t_err, time_step_NO_err]=NewmarkBetaReducedMethodwithINVMTX...
        (id_phi, inv_MTX_hat, MTX_init_free.M, MTX_init_free.C, MTX_init_free.K, ...
        Res, deltaT, 9.99, U0_sam, V0_sam, A0_sam, a0, a1, a2, a3, a4, a5, a6, a7, al, delta);
    %%
    err=norm(U_err, 'fro')/norm(U_sam_R, 'fro');
    err_store(i_sam)=err_store(i_sam)+err;
    
end
% =========================================================================
toc

























