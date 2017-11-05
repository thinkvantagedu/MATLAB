function aml=PlaneFrameMemberDistributionLoad(pj,pk,q,xq)
dp=pk-pj;
L=norm(dp);
cx=dp(1)/L;
cy=dp(2)/L;
a=xq(1);
b=xq(2);
R=[cx cy;...
    -cy cx];
R2T=[R zeros(2);...
    zeros(2) R];
IQ01=[1 0 0 0;...
    0 0 1 0;...
    0 1 0 0;...
    0 0 0 1];
qm=IQ01'*R2T*IQ01*q;

qxa=qm(1);qxb=qm(2);
qya=qm(3);qyb=qm(4);

aml1=-(b-a)/2/L*((L-2*a/3-b/3)*qxa+(L-a/3-2*b/3)*qxb);
aml4=-(b-a)/2/L*((2*a/3+b/3)*qxa+(a/3+2*b/3)*qxb);

kcey=qya-(qyb-qya)*a/(b-a);
ety=(qyb-qya)/(b-a);

aml2=-1/L^3*(kcey*L^3*(b-a)+0.5*ety*L^3*(b^2-a^2)-kcey*L*(b^3-a^3)...
    +0.25*(2*kcey-3*ety*L)*(b^4-a^4)+0.4*ety*(b^5-a^5));

aml5=-1/L^3*(kcey*L*(b^3-a^3)-0.25*(2*kcey-3*ety*L)*(b^4-a^4)...
    -0.4*ety*(b^5-a^5));

aml3=-1/L^2*(0.5*kcey*L^2*(b^2-a^2)-1/3*(2*kcey*L-ety*L^2)*(b^3-a^3)...
    +0.25*(kcey-2*ety*L)*(b^4-a^4)+0.2*ety*(b^5-a^5));

aml6=1/L^2*(1/3*kcey*L*(b^3-a^3)-0.25*(kcey-ety*L)*(b^4-a^4)...
    -0.2*ety*(b^5-a^5));

aml=[aml1;aml2;aml3;aml4;aml5;aml6];