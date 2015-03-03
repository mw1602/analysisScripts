# this helper script makes all the folders necessary for theexperiment class in mne python
# you need to be in the upper level that contains all your subjects folders 

import os
import sys
import shutil

if __name__ == '__main__': #runs from the command line
    subject = sys.argv[1] #first argument is subject

    directories = ['epoch selection', 'evoked', 'raw', 'plots', 'res', 'test']
    for directory in directories:
        dirname = '{0}/{1}'.format(subject, directory)
        if not os.path.isdir('./meg/' + dirname + '/'):
            os.mkdir('./meg/' + dirname + '/') #create directories for each subject if they don't exist

    sourcedir = './meg/{0}/'.format(subject)
    destination = './meg/{0}/raw/'.format(subject)

    source = os.listdir(sourcedir)
    for files in source:
        filep = './meg/{0}/{1}'.format(subject,files)
        if filep.endswith('.sqd') or filep.endswith('.txt'):
            shutil.move(filep, destination) #move textfiles to raw directory







