function[epochMatrix] = epochData(timeseries, epochlength)

%how many trials are there in the timeseries

amountTrials = size(timeseries,1);
epoch_extra = epochlength -1;

%for each trial, split into epochs of 24 s (12 TRs)

epochMatrix = zeros(amountTrials-epoch_extra,epochlength);

    
    for i=1:(amountTrials-epoch_extra) %can only use trials that have 11 TRs following them
        
                   
        epoch = timeseries(i:(i+epoch_extra));        
   
             
        epochMatrix(i,:) = epoch;
        
        
    end 
    

end