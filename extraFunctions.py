### this script contains extra processing functions that I wrote to interface with MNE Python

import os
import mne
from eelbrain import *
from SpecLevels import *
import pandas as pd 
import matplotlib.pyplot as plt
from surfer import Brain
import numpy as np
from matplotlib.lines import Line2D 


e = SpecLevels('/Users/Masha/Documents/Spec_Levels') # this loads my experiment class 
e.set_inv('free',snr=3) #set parameters for the inverse solution
e.set(cov='reg')

def loadDS(): # load the dataset into the workspace
	ds = e.load_evoked_stc('good', morph_ndvar = True, model = 'specificity%n_words')
	return ds

def loadTest(path): #load results of a test into the workspace
	res = load.unpickle(path)
	return res

def getCluster(res, cluster_no): # select relevant cluster from cluster permutation test results
	cluster = res.clusters[cluster_no, 'cluster']
	return cluster

def getSpatioTemporalIndex(cluster): #helper function
	index = cluster!=0
	return index

def getSpatialIndex(cluster):
	c_extent = cluster.sum('time') #helper function
	index = c_extent!=0
	return index

def plotCluster(cluster): # gets the cluster's extend in space and plots it on an inflated brain
	c_extent = cluster.sum('time')
	brain_plot = plot.brain.cluster(c_extent, surf = 'inflated', background = 'white', views = ['l'])
	return brain_plot

def saveClusterLabel(cluster, labelname): #save new label to disk in case I want to rerun a test
	labels = labels_from_clusters(cluster.sum('time'), names = labelname)
	mne_fixes.write_labels_to_annot(labels, 'fsaverage', labelname, subjects_dir=e.get('mri-sdir'))


def subRegion(ds, parc, region):
	#select the subset of sources from the dataset that are in the relevant label
	srcm = ds['srcm']
	srcm.source.set_parc(parc)
	srcm_region = srcm.sub(source = region)
	ds['srcm'] = srcm_region
	return ds

def extractAverageTimeCourse(ds, model, cluster): #get average over space by conditions

	# get index

	index = getSpatialIndex(cluster)
	
	# aggregate the ds over subjects

	ds_agg = ds.aggregate(model, drop_bad = True)
	relevant_factors = ds_agg[['n_words','specificity']] #choose only factors relevant for the interaction
	relevant_factors = pd.DataFrame(relevant_factors) #create a pandas dataframe with conditions
	relevant_factors['Conditions'] = relevant_factors['specificity'] + relevant_factors['n_words'] #single unique condition column

	# get the means over the source in cluster index
	timecourse_agg = ds_agg['srcm'].mean(index)
	pd_ds = pd.DataFrame(timecourse_agg.x) #extract the values and insert into pandas dataframe
	pd_ds.index = relevant_factors['Conditions'] #index by previously created condition index
	pd_ds = pd_ds.transpose() #get the data in the correct row-column format
	new_order = ['SuperOne', 'SuperTwo', 'BasicOne', 'BasicTwo', 'Sub1One', 'Sub1Two', 'Sub2One', 'Sub2Two'] #reorder conditions according to the logic of the experiment
	labels = ['Super One', 'Super Two', 'Basic One', 'Basic Two', 'Sub1 One', 'Sub1 Two', 'Sub2 One', 'Sub2 Two'] #prettify the labels
	pd_ds_ordered  = pd_ds[new_order] #reorder conditions
	return pd_ds_ordered

def plotWaveForms(pd_ds_ordered):

	#plot wave forms averaged over sources in the cluster in matplotlib

	colorlist = ['#253494', '#253494', '#2c7fb8', '#2c7fb8', '#41b6c4', '#41b6c4', '#7fcdbb','#7fcdbb'] #chose colors for bar graph from colorbrewer
	lines = ['--','-', '--','-','--','-','--','-'] #dotted lines for one word condition
	new_x = np.arange(-100,605,5) #fix the x-axis
	fig = plt.figure()
	ax = fig.add_subplot(111)

	#add each condition separately, to control color and linestyle
	for i in range(8):
		series = pd_ds_ordered[pd_ds_ordered.columns[i]]
		series.plot(x=new_x, linewidth = 4, ylim = (0,2), color = colorlist[i], linestyle= lines[i], label = labels[i])

	#general prettification of the plot:

	ax.grid(False) #remove weird background lines

	legend = ax.legend(loc='upper left', shadow=False, fontsize = 20, frameon = False)

	xticks = ['-100','0','100','200','300','400','500','600']
	ax.set_xticklabels(xticks, fontsize=24)
	ax.tick_params(axis='both', labelsize = 24, width = 3, length = 10)
	ax.set_xlabel('Time (ms)', fontsize = 24)
	ax.set_ylabel('Mean Activity (dSPM units)', fontsize = 24)

	ax.spines['top'].set_visible(False)
	ax.spines['right'].set_visible(False)
	ax.spines['bottom'].set_linewidth(4)
	ax.spines['left'].set_linewidth(4)
	ax.yaxis.set_ticks_position('left')
	ax.xaxis.set_ticks_position('bottom')

	plt.show()


def getBarMeans(ds, model, cluster): 
	# get index over time and space of the cluster
	st_index = getSpatioTemporalIndex(cluster)

	# extract relevant information from the dataset
	relevant_factors = ds[['subject','n_words','specificity']]
	relevant_factors = pd.DataFrame(relevant_factors) #create pandas dataframe

	# mean over sources and time points
	timecourse_means = ds['srcm'].mean(st_index)


	pd_ds = pd.Series(timecourse_means.x) #extract data
	relevant_factors['values'] =  pd_ds
	grouped = relevant_factors.groupby(('n_words', 'specificity')).mean() #get means by condition
	return grouped

def getBarVariability(ds, st_index): #get the within-subjects standard error for a repeated measures design
	import eelbrain as eel
	#create the model
	model = ds['specificity']%ds['n_words']
	subject_factor = ds['subject']
	timecourse_means = ds['srcm'].mean(st_index)
	standard_dev = eel._stats.stats.variability(timecourse_means.x, model, match = subject_factor, spec = 'sem', pool = True)
	return standard_dev


def saveCSV(dataframe, name): #write a dataframe to csv
	dataframe.to_csv('/Users/masha/Documents/Spec_Levels/{0}.csv').format(name)

def plotLabel(parc, alpha, color): #plot a label on a freesurfer inflated brain
	os.environ['SUBJECTS_DIR']='/Users/masha/Documents/Spec_Levels/mri'
	brain = Brain('fsaverage', 'lh', 'inflated',config_opts={'background':'white'})

	brain.add_label(parc[0], color = color, alpha = alpha)
	return brain

def plotBar(df, standard_dev): #plot bar graph according to specifications
	values = df['values']
	fig, ax = plt.subplots()
	one_means = values['One']
	one_means = one_means.reindex(['Super', 'Basic', 'Sub1', 'Sub2'])
	two_means = values['Two']
	two_means = two_means.reindex(['Super', 'Basic', 'Sub1', 'Sub2'])
	st_devs = [standard_dev]*4
	colorlist = ['#253494', '#2c7fb8', '#41b6c4', '#7fcdbb']
	labels = ['Super', 'Basic', 'Sub1', 'Sub2']

	# set x locations for bars

	ind = np.arange(1,5)
	width = 0.35 # bar width


	one_bars= ax.bar(ind+width,one_means, width, color=colorlist, yerr=st_devs, hatch = '/', edgecolor = 'k', linewidth = 2,error_kw=dict(ecolor='black', lw=2, capthick=2))

	two_bars= ax.bar(ind+2*width,two_means, width, color=colorlist, yerr=st_devs, edgecolor = 'k', linewidth=2, error_kw=dict(ecolor='black', lw=2, capthick=2))


	ax.set_ylabel('Mean Activity (dSPM units)', fontsize = 20)
	ax.set_xticks(ind+2*width)
	ax.set_xticklabels(labels, fontsize = 20)
	ax.tick_params(axis='y', labelsize = 20, width = 3, length = 10)
	ax.spines['top'].set_visible(False)
	ax.spines['right'].set_visible(False)
	ax.spines['bottom'].set_linewidth(2)
	ax.spines['left'].set_linewidth(2)
	ax.yaxis.set_ticks_position('left')
	ax.xaxis.set_ticks_position('none')
	# ax.ylim(0,2)

	plt.show()







