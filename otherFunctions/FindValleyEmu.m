function [valleyposition,valleyvalue,valleyE_mu]=...
    FindValleyEmu(lg10rdEmu,log_U_diff_U0)

global rd_n rdE_mu;

%valleyposition=zeros(9,1);

valleyposition=[];

for i_valley=1:rd_n-2
      
    if (log_U_diff_U0(i_valley)>log_U_diff_U0(i_valley+1))&&...
            (log_U_diff_U0(i_valley+1)<log_U_diff_U0(i_valley+2));
        
        valleyposition1=i_valley+1;
        
     valleyposition=[valleyposition;valleyposition1];
  
    end
           
end

valleyvalue=log_U_diff_U0(valleyposition);

valleyE_mu=rdE_mu(:,valleyposition);