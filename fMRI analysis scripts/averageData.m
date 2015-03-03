function[averaged_matrix] = averageData(averaged_epochs, plot_title)

fullTrials = size(averaged_epochs,1);
%need to read in the files listing the order of the runs

[run_order] = getRunOrder();

%then, delete last few trials that weren't put into the epoch

run_order = run_order(1:fullTrials);

%average together trial types that are the same

all_1 = [];
all_2 = [];
all_3 = [];
all_4 = [];

for i=1:fullTrials

    if run_order(i) == 1
        
        all_1 = [all_1 ; averaged_epochs(i,:)];
    
    elseif run_order(i) == 2
        
        all_2 = [all_2 ; averaged_epochs(i,:)];
    
    elseif run_order(i) == 3
        
        all_3 = [all_3 ; averaged_epochs(i,:)];
    

    elseif run_order(i) == 4 
        
        all_4 = [all_4 ; averaged_epochs(i,:)];
    
    end

end


%then average all the trial types

averaged_1 = mean(all_1,1);

se_1 = std(all_1)/sqrt(size(all_1,1));
averaged_2 = mean(all_2,1);
se_2 = std(all_2)/sqrt(size(all_2,1));
averaged_3 = mean(all_3,1);
se_3 = std(all_3)/sqrt(size(all_3,1));
averaged_4 = mean(all_4,1);
se_4 = std(all_4)/sqrt(size(all_4,1));

%concatenate them 

averaged_matrix = [averaged_1; averaged_2; averaged_3; averaged_4];
se_matrix = [se_1; se_2; se_3; se_4];

errorbar(averaged_matrix',se_matrix','LineWidth', 2);
title(plot_title);
xlabel('time (TRs)');
ylabel('fMRI response (% signal change)');
% 
% plot(averaged_matrix');
legend('visual right, orient right', 'visual right, orient left', 'visual left, orient right', 'visual left, orient left');

end