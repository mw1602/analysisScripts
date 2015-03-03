function [run_order] = getRunOrder()

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/EventRelated/');

run_file_1 = dlmread('responsesGratings_1112081317-trimmed.txt');

%grab only first column, with trial numbers 

run_order_1 = run_file_1(:,1);

%delete first two trials, since we deleted first two volumes

run_order_1 = run_order_1(3:length(run_order_1));

run_file_2 = dlmread('responsesGratings_1112081322-trimmed.txt');

%grab only first column, with trial numbers 

run_order_2 = run_file_2(:,1);

%delete first two trials, since we deleted first two volumes

run_order_2 = run_order_2(3:length(run_order_2));

run_file_3 = dlmread('responsesGratings_1112081327-trimmed.txt');

%grab only first column, with trial numbers 

run_order_3 = run_file_3(:,1);

%delete first two trials, since we deleted first two volumes

run_order_3 = run_order_3(3:length(run_order_3));

run_file_4 = dlmread('responsesGratings_1112081332-trimmed.txt');

%grab only first column, with trial numbers 

run_order_4 = run_file_4(:,1);

%delete first two trials, since we deleted first two volumes

run_order_4 = run_order_4(3:length(run_order_4));

run_file_5 = dlmread('responsesGratings_1112081337-trimmed.txt');

%grab only first column, with trial numbers 

run_order_5 = run_file_5(:,1);

%delete first two trials, since we deleted first two volumes

run_order_5 = run_order_5(3:length(run_order_5));

run_file_6 = dlmread('responsesGratings_1112081342-trimmed.txt');

%grab only first column, with trial numbers 

run_order_6 = run_file_6(:,1);

%delete first two trials, since we deleted first two volumes

run_order_6 = run_order_6(3:length(run_order_6));


%then  concatenate all of the trial runs

run_order = [run_order_1 ;run_order_2;run_order_3;run_order_4;run_order_5;run_order_6];

end