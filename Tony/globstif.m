function [gstif] = globstif(nnode,ndime,ndofn,nevab,ngaus,npoin,ntotv, nelem,lnods,coord,young,poiss,thick)

%-------------------------------------------------------------------------

% Form global stiffness matrix

%-------------------------------------------------------------------------

gstif(1:ntotv,1:ntotv)=0.0;

for ielem=1:nelem;
    
    estif=stiffps(nnode,ndime,nevab,ngaus,ielem,lnods,coord, young,poiss,thick);
    
    for in=1:nnode;
        
        nodei=lnods(ielem,in);
        
        for il=1:ndofn;
            
            ie=(in-1)*ndofn+il;
            
            ig=(nodei-1)*ndofn+il;
            
            for jn=1:nnode;
                
                nodej=lnods(ielem,jn);
                
                for jl=1:ndofn;
                    
                    je=(jn-1)*ndofn+jl;
                    
                    jg=(nodej-1)*ndofn+jl;
                    
                    gstif(ig,jg)=gstif(ig,jg)+estif(ie,je);
                    
                end;
                
            end
            
        end
        
    end
    
end