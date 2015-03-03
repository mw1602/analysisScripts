#helper script to extract and export single trial information from dataset

import pandas as pd
from SpecLevels import *

e = SpecLevels('/Users/Masha/Documents/Spec_Levels') # this loads my experiment class 
snr = 1 #regularization parameter should be lower for single trials 
# also should be using MNE, not dSPM, for single trial analysis
e.set_inv('free',snr=snr, method = 'MNE')
# e.set_inv('fixed',snr=snr, method = 'MNE')
e.set(cov='reg')

subjects = ['R0026', 'R0684', 'R0739', 'R0908', 'R0923', 'R0924', 'R0640', 'R0053', 'R0845', 'R0926', 'R0737', 'R0903', 'R0928', 'R0539', 'R0929', 'R0560', 'R0725', 'R0825', 'R0823', 'R0931'] #every subject number
# have to run this separately for each subject because otherwise you run out of memory
region = 'main_words-lh'
parc = 'main_words'


def runSubjects(subjects, region, parc):
	for subject in subjects: #loop through each subject for memory reasons
		print subject #keep track of progress...it's slow
		epochs = e.load_epochs_stc(subject = subject) #load epochs
		src = epochs['src']
		src.source.set_parc(parc) #subset to relevant sources
		
		src_region = src.sub(source = region)
		epochs['src'] = src_region

		# now average over sources in ROI

		timecourse = epochs['src'].mean('source')

		# pick out the time window we're interested in

		timecourse_early = timecourse.sub(time=(0.2,0.3)) 
		timecourse_late = timecourse.sub(time=(0.3,0.4))

		# then average over time to get a single number

		early = timecourse_early.mean('time')
		late = timecourse_late.mean('time')

		# now add back to the ds

		epochs['early'] = early
		epochs['late'] = late

		# write out to a txt file

		epochs.save_txt('{0}_{1}_{2}_{3}_singletrial.txt'.format(subject, region, parc))


def compileFiles(subjects, region): #get all trials out of subject files
	# create larger array

all_trials = pd.DataFrame()

for subject in subjects:
	filename = '{0}_{1}_singletrial.txt'.format(subject, region)
	subject_df = pd.read_csv(filename, delimiter = '\t')
	subject_df['subject'] = subject
	all_trials = all_trials.append(subject_df)

all_trials.to_csv('all_trials_{0}_{1}.csv'.format(region, snr))

def averageSubjects(subjects, region, parc): #get an average of single trial information, just to inspect visually
	datasets = []
	for subject in subjects:
		print subject
		epochs = e.load_epochs_stc(subject = subject)
		src = epochs['src']
		src.source.set_parc(parc)
		
		src_region = src.sub(source = region)
		epochs['src'] = src_region

		epochs_agg = epochs.aggregate('specificity%n_words', drop_bad = True)

		datasets.append(epochs_agg)
		del epochs


	for datas in datasets:
		datas['timecourse'] = datas.pop('src').mean('source')
	ds_combined = combine(datasets)
	plot.UTSStat(ds_combined['timecourse'], 'specificity%n_words', match = 'subject', ds = ds_combined)








