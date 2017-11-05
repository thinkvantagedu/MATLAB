function [K_Im]=MOR_StiffnessMatrixMain(Em, EI, parameterm, parameteri, ...
     inclusion, elem_mp, nd, elem_cd)

%%
[circled_bm]=CircleBeamNO(elem_cd,elem_mp, inclusion);

%%

for i_em_mp=circled_bm
    
    elem_mp(i_em_mp,3)=EI;
    elem_mp(i_em_mp,4)=parameteri.AI;
    elem_mp(i_em_mp,5)=parameteri.II;
   
end

[K_Im]=StiffnessMatrixAssemble(nd, elem_cd, elem_mp);
