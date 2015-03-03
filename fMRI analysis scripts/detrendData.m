function[epochMatrix] = detrendData(timeseries, epochlength)

%how many trials are there in the timeseries

amountTrials = size(timeseries,1);
amountVoxels = size(timeseries,2);
epoch_extra = epochlength -1;
%for each trial, split into epochs of 24 s (12 TRs)

epochMatrix = zeros(amountVoxels,(amountTrials-epoch_extra),epochlength);

for i=1:amountVoxels
    
    for j=1:(amountTrials-epoch_extra) %can only use trials that have 11 TRs following them
        
             epochdetrend =[];   
        
        epoch = timeseries(j:(j+epoch_extra),i);        
   
        
        %detrend
        
        for k=1:length(epoch)
           
          detrended = epoch(k) -epoch(1);  
          epochdetrend = [epochdetrend detrended];
          
        end    
        
        epochMatrix(i,j,:) = epochdetrend;
        
        
    end 
    
end


end