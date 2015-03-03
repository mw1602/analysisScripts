function[betas] = convolveFit2(detrended_epochs, run)

%now convolve design matrix with hrf



[run_order] = getRunOrder();

run_order = run_order(123*(run-1)+1:123*run);

%parameters

tau = 2; 
delta=0;
TR=2;
nTrials = length(run_order);

%create design matrix with one column per trial type

responseMatrix = zeros(nTrials,2);

frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 1 || trialType == 2      
        
                  
       responseMatrix(frame,1) = 1;
     
      
         frame = frame + 1;
    
    elseif trialType == 3 || trialType == 4     
        
                  
       responseMatrix(frame,2) = 1;
     
        frame = frame + 1;
        
    
   else
        
        frame = frame +1;
    end
end

designMatrix = zeros(nTrials,2);

    for i=1:2
    
   designMatrix(:,i) = hrfconv(responseMatrix(:,i),tau,delta,TR); 


    end
  



betas = designMatrix\detrended_epochs;



end








