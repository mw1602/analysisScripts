function[betas] = convolveFit3(detrended_epochs, run_order)

%now convolve design matrix with hrf

%parameters

tau = 2; 
delta=0;
TR=2;
nTrials = length(run_order);

%create design matrix with one column per trial type

responseMatrix = zeros(nTrials,4);

frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 1       
        
                  
       responseMatrix(frame,1) = 1;
     
      
         frame = frame + 1;
    elseif trialType == 2       
        
                  
       responseMatrix(frame,2) = 1;
     
        frame = frame + 1;
        
    elseif trialType == 3
        
        responseMatrix(frame,3) =1;
         frame = frame + 1;
         
    elseif trialType ==4
        
        responseMatrix(frame,4) =1;
         frame = frame + 1;
    else
        
        frame = frame +1;
    end
end

designMatrix = zeros(nTrials,4);

%separately convolve for every run

amountSubTrials = nTrials/6;

for j=1:6
    
responseMatrix_partial = responseMatrix((j-1)*amountSubTrials+1:j*amountSubTrials,:);

    for i=1:4
    
   designMatrix((j-1)*amountSubTrials+1:j*amountSubTrials,i) = hrfconv(responseMatrix_partial(:,i),tau,delta,TR); 


    end

end

betas = designMatrix\detrended_epochs;

end








