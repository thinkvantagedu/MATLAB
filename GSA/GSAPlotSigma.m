function GSAPlotSigma(sigma_store, pm_val)

sigma.length=(1:length(sigma_store));
titl=sprintf('Singular value decay curve for each SVD, magic point = [%d %d]', pm_val(1), pm_val(2));
suptitle(titl);
subplot(1, 2, 1);
plot(sigma.length, sigma_store);
xlabel('iterations');
ylabel('singular values')

sigma_log_store=zeros(size(sigma_store));
for i=1:length(sigma_store)
    
    sigma_log_store(i, :)=sigma_log_store(i, :)+log10(sigma_store(i, :));
     
end

subplot(1, 2, 2);
plot(sigma.length, sigma_log_store);
xlabel('iterations');
ylabel('log singular values')