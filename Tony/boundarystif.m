function [rhsmod,gstifmod]=boundarystif(ndofn,ntotv,nvfix,nofix,ifpre,presc, gstif,rhs)

%--------------------------------------------------------------------------

% Modify stiffness matrix and force vector for fixed and

% prescribed nodes

%--------------------------------------------------------------------------

rhsmod=rhs;

gstifmod=gstif;

% Modify r.h.s. for fixed d.o.f, then zero associated row and column ;

% set diagonal term of fixed dof to original value and modify rhs

for iv=1:nvfix;
    
    for id=1:ndofn;
        
        if ifpre(iv,id)~=0 ;
            
            ig=(nofix(iv)-1)*ndofn+id;
            
            for i=1:ntotv;
                
                rhsmod(i)=rhsmod(i)-presc(iv,id)*gstif(i,ig);
                
                gstifmod(ig,i)=0.0 ; gstifmod(i,ig)=0.0 ;
                
            end
            
            gstifmod(ig,ig)=gstif(ig,ig);
            
        end
        
    end
    
end

for iv=1:nvfix;
    
    for id=1:ndofn;
        
        if ifpre(iv,id)~=0 ;
            
            ig=(nofix(iv)-1)*ndofn+id;
            
            rhsmod(ig)=presc(iv,id)*gstif(ig,ig) ;
            
        end
        
    end
    
end