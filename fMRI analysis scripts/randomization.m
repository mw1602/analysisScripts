%randomization test

function[p_values, sort_betas] = randomization(timeseries)


%get the run order

[run_order] = getRunOrder();

%get real parameter values 

betas_real = convolveFit3(timeseries, run_order);


betas = zeros(4,1000);

%loop through permutations 1000 times

for i =1:1000
    
    
    
    %randomly permute the trials
    
    run_order_perm = run_order(randperm(length(run_order)));
    
    
    %linear regression to get parameter estimates
    
    betas(:,i) = convolveFit3(timeseries, run_order_perm);
    
      
    
end    

p_values = zeros(4,1);

%for each trial type, find p_value

for i = 1:4
    
   real_beta = betas_real(i); 
    
   betas_trial = betas(i,:);
   

%find how many of the permutations have a larger value than
%the real beta

sort_betas = sort(betas_trial,'ascend');


smaller_perms = find(sort_betas > real_beta,1);

if smaller_perms >=1

%to find the p-value, need this to be between 0 and 1

p_values(i) = smaller_perms/1000;

else
    
    p_values(i) = 0;
    
end    
end    

end