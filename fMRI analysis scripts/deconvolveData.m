function[betas, responseMatrix] = deconvolveData(detrended_epochs, plot_title)


[run_order] = getRunOrder();

nTrials = length(run_order); %trim it to be the length of the TRs...


responseMatrix_1 = zeros(nTrials,12);
frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 1       
        
       
        for j=0:11
            
        responseMatrix_1(frame+j,j+1) = 1;
       
        
        end
         frame = frame + 1;
    else
        frame = frame + 1;
    end
end

%trim the extra added rows that go over the length of the run 

responseMatrix_1 = responseMatrix_1(1:nTrials,:);

responseMatrix_2 = zeros(nTrials,12);
frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 2       
        
       
        for j=0:11
            
        responseMatrix_2(frame+j,j+1) = 1;
       
        
        end
         frame = frame + 1;
    else
        frame = frame + 1;
    end
end

%trim the extra added rows that go over the length of the run 

responseMatrix_2 = responseMatrix_2(1:nTrials,:);

responseMatrix_3 = zeros(nTrials,12);
frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 3       
        
       
        for j=0:11
            
        responseMatrix_3(frame+j,j+1) = 1;
       
        
        end
         frame = frame + 1;
    else
        frame = frame + 1;
    end
end

%trim the extra added rows that go over the length of the run 

responseMatrix_3 = responseMatrix_3(1:nTrials,:);

responseMatrix_4 = zeros(nTrials,12);
frame = 1;

for trial = 1:nTrials
    trialType = run_order(trial);
    
    if trialType == 4       
        
       
        for j=0:11
            
        responseMatrix_4(frame+j,j+1) = 1;
       
        
        end
         frame = frame + 1;
    else
        frame = frame + 1;
    end
end

%trim the extra added rows that go over the length of the run 

responseMatrix_4 = responseMatrix_4(1:nTrials,:);


%concatenate them all

responseMatrix = [responseMatrix_1 responseMatrix_2 responseMatrix_3 responseMatrix_4];


% %do a regression 
% % 
betas = responseMatrix\detrended_epochs;

%plot the responses
% figure();
plot(betas(1:12),'b','LineWidth', 2);
hold on
plot(betas(13:24),'g','LineWidth', 2);
plot(betas(25:36),'r','LineWidth', 2);
plot(betas(37:48),'c','LineWidth', 2);
title(plot_title);
xlabel('time (TRs)');
ylabel('fMRI response (% signal change)');

legend('visual right, orient right', 'visual right, orient left', 'visual left, orient right', 'visual left, orient left');


end