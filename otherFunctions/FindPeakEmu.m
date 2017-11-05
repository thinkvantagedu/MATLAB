function [peakposition,peakvalue,peakE_mu]=...
    FindPeakEmu(lg10rdEmu,log_U_diff_U0)

global rd_n rdE_mu;

%peakposition=zeros(9,1);

peakposition=[];

for i_peak=1:rd_n-2
     
    if (log_U_diff_U0(i_peak)<log_U_diff_U0(i_peak+1))&&...
            (log_U_diff_U0(i_peak+1)>log_U_diff_U0(i_peak+2));
        
        peakposition1=i_peak+1;
        
     peakposition=[peakposition;peakposition1];
     
    end
         
end

peakvalue=log_U_diff_U0(peakposition);

peakE_mu=rdE_mu(:,peakposition);