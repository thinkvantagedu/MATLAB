clear variables; clc;
% M=[2 0; 0 1];
% C=[0 0; 0 0];
% K=[6 -2; -2 4];
% t=[0:2.8:28];
% nt=10; % number of time steps
% R=zeros(length(M), 10);
% for i=1:10
%    
%     R(:, i)=R(:, i)+[0; 10];
%     
% end
% q0=[0; 0];
% qdot0=[0; 0];
% gamma=1/2;
% beta=1/4;
% [q, qdot, q2dot] = modifiednewmarkint(M, C, K, R, q0, qdot0, t);
% [u, udot, u2dot] = newmark_int(t, R, q0, qdot0, M, K, C);

% deltaT=t(2)-t(1);
% dof=length(M);
% a1=gamma/(beta*deltaT);
% a2=1/(beta*deltaT^2);
% a3=1/(beta*deltaT);
% a4=gamma/beta;
% a5=1/(2*beta);
% a6=(gamma/(2*beta)-1)*deltaT;
% 
% q=zeros(n, nt);
% qdot=zeros(n, nt);
% q2dot=zeros(n, nt);
% 
% q(:, 1)=q0;
% qdot(:, 1)=qdot0;
% q2dot(:, 1)=M\(R(:, 1)-C*qdot(:, 1)-K*q(:, 1));
% 
% A=K+a1*C+a2*M;
% 
% a=a3*M+a4*C;
% b=a5*M+a6*C;






















