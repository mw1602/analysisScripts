%assignment 8
%trial triggered average

%load the ROIs


cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/');

right_motor = readinNifti('right_motor3.nii');

left_motor = readinNifti('left_motor3.nii');

left_calc = readinNifti('left_calc3.nii');

right_calc = readinNifti('right_calc3.nii');

test = readinNifti('test_roi.nii');


%load the runs (and delete the first 2 volumes) and store in a cell array
%called runs

runs = {};

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/10+cbi_seg_epi_gre/');

runs{1} = readinNifti('111208131858.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(runs{1},4);

%delete first two volumes of epi

runs{1} = runs{1}(:,:,:,3:numFrames);


cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/11+cbi_seg_epi_gre2/');

runs{2} = readinNifti('111208132403.nii');


% How long (number of temporal frames) are the time series?
numFrames = size(runs{2},4);

%delete first two volumes of epi

runs{2} = runs{2}(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/12+cbi_seg_epi_gre2/');

runs{3} = readinNifti('111208132831.nii');


% How long (number of temporal frames) are the time series?
numFrames = size(runs{3},4);

%delete first two volumes of epi

runs{3} = runs{3}(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/13+cbi_seg_epi_gre4/');

runs{4} = readinNifti('111208133329.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(runs{4},4);

%delete first two volumes of epi

runs{4} = runs{4}(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/14+cbi_seg_epi_gre5/');

runs{5} = readinNifti('111208133822.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(runs{5},4);

%delete first two volumes of epi

runs{5} = runs{5}(:,:,:,3:numFrames);

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/15+cbi_seg_epi_gre5/');

runs{6} = readinNifti('111208134248.nii');

% How long (number of temporal frames) are the time series?
numFrames = size(runs{6},4);

%delete first two volumes of epi

runs{6} = runs{6}(:,:,:,3:numFrames);


%extract time series at each voxel and convert runs to % signal change,
%then detrend

% left_motor

leftmotor_Tseries_1 = timeCourse(left_motor, runs{1});
leftmotor_Tseries_2 = timeCourse(left_motor, runs{2});
leftmotor_Tseries_3 = timeCourse(left_motor, runs{3});
leftmotor_Tseries_4 = timeCourse(left_motor, runs{4});
leftmotor_Tseries_5 = timeCourse(left_motor, runs{5});
leftmotor_Tseries_6 = timeCourse(left_motor, runs{6});

%concatenate time course by runs

lm_timeSeries = cat(1, leftmotor_Tseries_1,leftmotor_Tseries_2,leftmotor_Tseries_3,leftmotor_Tseries_4,leftmotor_Tseries_5,leftmotor_Tseries_6);


%cut into epochs of 12 TRs, ditching the last 11 trials (can't break into
%epochs) 

epochlength = 12; 
tau = 2; 
delta =0;
TR=2;

lm_epoched = epochData(lm_timeSeries, epochlength);

%trial triggered average

[averaged_leftmotor] = averageData(lm_epoched, 'Trial Triggered Average (left motor ROI)');


%deconvolution
hold on;
[betas_lm, responseMatrix_lm] = deconvolveData(lm_timeSeries, 'Deconvolved Time Course (left motor ROI)');

%fit the data


[betas, designMatrix, averaged_fMRImatrix] = convolveFit(lm_timeSeries);


%parameter estimates

cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/eventrelatedcorrect/12+cbi_seg_epi_gre2/');
[data, dataHeader] = readinNifti('111208132831.nii');
dataHeader.datatype='double';
[parameter_estimates,t_values,p_values] = SPM (design_lm, tau, delta, TR, runs,1);
cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/');
writeNifti('lm_tmap2_4.nii', t_values(:,:,:,4), dataHeader);
writeNifti('lm_pmap2_4.nii', p_values(:,:,:,4), dataHeader);
writeNifti('lm_parameters2_4.nii', parameter_estimates(:,:,:,4), dataHeader);
clear p_values
clear parameter_estimates
clear t_values

[parameter_estimates,t_values,p_values] = SPM (design_lm, tau, delta, TR, runs,2);
cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/');
writeNifti('lm_tmap_2.nii', t_values, dataHeader);
writeNifti('lm_pmap_2.nii', parameter_estimates, dataHeader);
writeNifti('lm_pmap_2.nii', p_values, dataHeader);
writeNifti('lm_parameters_2.nii', parameter_estimates, dataHeader);
clear p_values
clear parameter_estimates
clear t_values

[parameter_estimates,t_values,p_values] = SPM (design_lm, tau, delta, TR, runs,3);
cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/');
writeNifti('lm_tmap_3.nii', t_values, dataHeader);
writeNifti('lm_pmap_3.nii', parameter_estimates, dataHeader);
writeNifti('lm_pmap_3.nii', p_values, dataHeader);
writeNifti('lm_parameters_3.nii', parameter_estimates, dataHeader);
clear p_values
clear parameter_estimates
clear t_values

[parameter_estimates,t_values,p_values] = SPM (design_lm, tau, delta, TR, runs,4);
cd('/Volumes/server/NEUROLING/Personal_Files/Masha Westerlund/fMRI course/assignment 8/');
writeNifti('lm_tmap_4.nii', t_values, dataHeader);
writeNifti('lm_pmap_4.nii', parameter_estimates, dataHeader);
writeNifti('lm_pmap_4.nii', p_values, dataHeader);
writeNifti('lm_parameters_4.nii', parameter_estimates, dataHeader);
clear p_values
clear parameter_estimates
clear t_values

%right_motor

rightmotor_Tseries_1 = timeCourse(right_motor, runs{1});
rightmotor_Tseries_2 = timeCourse(right_motor, runs{2});
rightmotor_Tseries_3 = timeCourse(right_motor, runs{3});
rightmotor_Tseries_4 = timeCourse(right_motor, runs{4});
rightmotor_Tseries_5 = timeCourse(right_motor, runs{5});
rightmotor_Tseries_6 = timeCourse(right_motor, runs{6});


%concatenate time course by runs

rm_timeSeries = cat(1, rightmotor_Tseries_1,rightmotor_Tseries_2,rightmotor_Tseries_3,rightmotor_Tseries_4,rightmotor_Tseries_5,rightmotor_Tseries_6);


%cut into epochs of 12 TRs, ditching the last 11 trials (can't break into
%epochs) 

epochlength = 12; 

rm_epoched = epochData(rm_timeSeries, epochlength);

%trial triggered average

[averaged_rightmotor] = averageData(rm_epoched, 'Trial Triggered Average (right motor ROI)');

%deconvolution

[betas_rm] = deconvolveData(rm_timeSeries, 'Deconvolved Time Course (right motor ROI)');

%fit the data


[betas_fitted_rm, design_rm, epochMatrix_rm] = convolveFit(rm_timeSeries);


%left calc

leftcalc_Tseries_1 = timeCourse(left_calc, runs{1});
leftcalc_Tseries_2 = timeCourse(left_calc, runs{2});
leftcalc_Tseries_3 = timeCourse(left_calc, runs{3});
leftcalc_Tseries_4 = timeCourse(left_calc, runs{4});
leftcalc_Tseries_5 = timeCourse(left_calc, runs{5});
leftcalc_Tseries_6 = timeCourse(left_calc, runs{6});


%concatenate time course by runs

lc_timeSeries = cat(1, leftcalc_Tseries_1,leftcalc_Tseries_2,leftcalc_Tseries_3,leftcalc_Tseries_4,leftcalc_Tseries_5,leftcalc_Tseries_6);


%cut into epochs of 12 TRs, ditching the last 11 trials (can't break into
%epochs) 

epochlength = 12; 

lc_epoched = epochData(lc_timeSeries, epochlength);

%trial triggered average
hold on;

[averaged_leftcalc] = averageData(lc_epoched, 'Trial Triggered Average (left calcarine ROI)');

%deconvolution
[betas_lc] = deconvolveData(lc_timeSeries, 'Deconvolved Time Course (left calcarine ROI)');

%fit the data

[betas_fitted_lc, design_lc, epochMatrix_lc] = convolveFit(lc_timeSeries);

%right calc

rightcalc_Tseries_1 = timeCourse(right_calc, runs{1});
rightcalc_Tseries_2 = timeCourse(right_calc, runs{2});
rightcalc_Tseries_3 = timeCourse(right_calc, runs{3});
rightcalc_Tseries_4 = timeCourse(right_calc, runs{4});
rightcalc_Tseries_5 = timeCourse(right_calc, runs{5});
rightcalc_Tseries_6 = timeCourse(right_calc, runs{6});

%concatenate time course by runs

rc_timeSeries = cat(1, rightcalc_Tseries_1,rightcalc_Tseries_2,rightcalc_Tseries_3,rightcalc_Tseries_4,rightcalc_Tseries_5,rightcalc_Tseries_6);


%cut into epochs of 12 TRs, ditching the last 11 trials (can't break into
%epochs) 

epochlength = 12; 

rc_epoched = epochData(rc_timeSeries, epochlength);

%trial triggered average

[averaged_rightcalc] = averageData(rc_epoched, 'Trial Triggered Average (right calcarine ROI)');

%deconvolution
hold on;
[betas_rc] = deconvolveData(rc_timeSeries, 'Deconvolved Time Course (right calcarine ROI)');

%fit the data

[betas_fitted_rc, design_rc, epochMatrix_rc] = convolveFit(rc_timeSeries);

%test roi

test_Tseries_1 = timeCourse(test, runs{1});
test_Tseries_2 = timeCourse(test, runs{2});
test_Tseries_3 = timeCourse(test, runs{3});
test_Tseries_4 = timeCourse(test, runs{4});
test_Tseries_5 = timeCourse(test, runs{5});
test_Tseries_6 = timeCourse(test, runs{6});


%concatenate time course by runs

test_timeSeries = cat(1, test_Tseries_1,test_Tseries_2,test_Tseries_3,test_Tseries_4,test_Tseries_5,test_Tseries_6);


