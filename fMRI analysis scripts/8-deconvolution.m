%assignment 8
%deconvolution

%load the ROIs


cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/');

right_motor = readinNifti('right motor.nii');

left_motor = readinNifti('left motor.nii');

left_calc = readinNifti('left calcarine.nii');

right_calc = readinNifti('right calcarine.nii');


%load the runs (and delete the first 2 volumes)

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/10+cbi_seg_epi_gre/');

run_1 = readinNifti('111208131858.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(run_1,4);

%delete first two volumes of epi

run_1 = run_1(:,:,:,3:numFrames);


cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/11+cbi_seg_epi_gre2/');

run_2 = readinNifti('111208132403.nii');


% How long (number of temporal frames) are the time series?
numFrames = size(run_2,4);

%delete first two volumes of epi

run_2 = run_2(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/12+cbi_seg_epi_gre2/');

run_3 = readinNifti('111208132831.nii');


% How long (number of temporal frames) are the time series?
numFrames = size(run_3,4);

%delete first two volumes of epi

run_3 = run_3(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/13+cbi_seg_epi_gre4/');

run_4 = readinNifti('111208133329.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(run_4,4);

%delete first two volumes of epi

run_4 = run_4(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/14+cbi_seg_epi_gre5/');

run_5 = readinNifti('111208133822.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(run_5,4);

%delete first two volumes of epi

run_5 = run_5(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/15+cbi_seg_epi_gre5/');

run_6 = readinNifti('111208134248.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(run_6,4);

%delete first two volumes of epi

run_6 = run_6(:,:,:,3:numFrames);

%extract time series at each voxel and convert runs to % signal change,
%then detrend

% left_motor

leftmotor_Tseries_1 = timeCourse(left_motor, run_1);
leftmotor_1_matrix = detrendData(leftmotor_Tseries_1,12);
leftmotor_Tseries_2 = timeCourse(left_motor, run_2);
leftmotor_2_matrix = detrendData(leftmotor_Tseries_2,12);
leftmotor_Tseries_3 = timeCourse(left_motor, run_3);
leftmotor_3_matrix = detrendData(leftmotor_Tseries_3,12);
leftmotor_Tseries_4 = timeCourse(left_motor, run_4);
leftmotor_4_matrix = detrendData(leftmotor_Tseries_4,12);
leftmotor_Tseries_5 = timeCourse(left_motor, run_5);
leftmotor_5_matrix = detrendData(leftmotor_Tseries_5,12);
leftmotor_Tseries_6 = timeCourse(left_motor, run_6);
leftmotor_6_matrix = detrendData(leftmotor_Tseries_6,12);

%then concatenate into one huge matrix , by runs

leftmotor_Tseries = cat(2, leftmotor_1_matrix,leftmotor_2_matrix,leftmotor_3_matrix,leftmotor_4_matrix,leftmotor_5_matrix,leftmotor_6_matrix);



%right_motor

rightmotor_Tseries_1 = timeCourse(right_motor, run_1);
rightmotor_1_matrix = detrendData(rightmotor_Tseries_1,12);
rightmotor_Tseries_2 = timeCourse(right_motor, run_2);
rightmotor_2_matrix = detrendData(rightmotor_Tseries_2,12);
rightmotor_Tseries_3 = timeCourse(right_motor, run_3);
rightmotor_3_matrix = detrendData(rightmotor_Tseries_3,12);
rightmotor_Tseries_4 = timeCourse(right_motor, run_4);
rightmotor_4_matrix = detrendData(rightmotor_Tseries_4,12);
rightmotor_Tseries_5 = timeCourse(right_motor, run_5);
rightmotor_5_matrix = detrendData(rightmotor_Tseries_5,12);
rightmotor_Tseries_6 = timeCourse(right_motor, run_6);
rightmotor_6_matrix = detrendData(rightmotor_Tseries_6,12);

%then concatenate into one huge matrix , by runs

rightmotor_Tseries = cat(2, rightmotor_1_matrix,rightmotor_2_matrix,rightmotor_3_matrix,rightmotor_4_matrix,rightmotor_5_matrix, rightmotor_6_matrix);



%left calc

leftcalc_Tseries_1 = timeCourse(left_calc, run_1);
leftcalc_1_matrix = detrendData(leftcalc_Tseries_1,12);
leftcalc_Tseries_2 = timeCourse(left_calc, run_2);
leftcalc_2_matrix = detrendData(leftcalc_Tseries_2,12);
leftcalc_Tseries_3 = timeCourse(left_calc, run_3);
leftcalc_3_matrix = detrendData(leftcalc_Tseries_3,12);
leftcalc_Tseries_4 = timeCourse(left_calc, run_4);
leftcalc_4_matrix = detrendData(leftcalc_Tseries_4,12);
leftcalc_Tseries_5 = timeCourse(left_calc, run_5);
leftcalc_5_matrix = detrendData(leftcalc_Tseries_5,12);
leftcalc_Tseries_6 = timeCourse(left_calc, run_6);
leftcalc_6_matrix = detrendData(leftcalc_Tseries_6,12);

%then concatenate into one huge matrix , by runs

leftcalc_Tseries = cat(2, leftcalc_1_matrix, leftcalc_2_matrix,leftcalc_3_matrix,leftcalc_4_matrix,leftcalc_5_matrix,leftcalc_6_matrix); 




%right calc

rightcalc_Tseries_1 = timeCourse(right_calc, run_1);
rightcalc_1_matrix = detrendData(rightcalc_Tseries_1,12);
rightcalc_Tseries_2 = timeCourse(right_calc, run_2);
rightcalc_2_matrix = detrendData(rightcalc_Tseries_2,12);
rightcalc_Tseries_3 = timeCourse(right_calc, run_3);
rightcalc_3_matrix = detrendData(rightcalc_Tseries_3,12);
rightcalc_Tseries_4 = timeCourse(right_calc, run_4);
rightcalc_4_matrix = detrendData(rightcalc_Tseries_4,12);
rightcalc_Tseries_5 = timeCourse(right_calc, run_5);
rightcalc_5_matrix = detrendData(rightcalc_Tseries_5,12);
rightcalc_Tseries_6 = timeCourse(right_calc, run_6);
rightcalc_6_matrix = detrendData(rightcalc_Tseries_6,12);

%then concatenate into one huge matrix , by runs

rightcalc_Tseries = cat(2, rightcalc_1_matrix, rightcalc_2_matrix,rightcalc_3_matrix,rightcalc_4_matrix,rightcalc_5_matrix,rightcalc_6_matrix);


