# this script will create 8 blocks of randomly distributed trials from the master list of the experiment, with the following constraints:
# -each block will have the same number of items
#-each block will contain the same number of items from each group (e.g. 'furniture')
#-each block will contain no repetitions of the same noun or the same adjective (for counterbalancing)


from collections import defaultdict
import pandas
import numpy as np
import sys

# set the number of desired blocks
blocks = 8

# read in the master list of trials

if sys.platform.startswith('win32'): # for cross-platform compatibility across laptop and work computer
    filepath = 'C:\Users\dailyuser\Dropbox\Dissertation Proposal\Experiment Script\\'
else:
    filepath = '/Users/masha/Dropbox/Dissertation Proposal/Experiment Script/'
    

master_list = pandas.read_csv(filepath + 'all_items_withvalues_halftask_FIXED.csv') #read in all trials
rows = len(master_list.index)

#subset the master list for only the columns I want
sub_list = master_list[['Adj', 'Noun', 'Words', 'Group', 'Item', 'Level', 'Task1', 'Task2', 'Correct_Task', 'Correct_Task_Num', 'Adj_Trigger', 'Target_Trigger', 'Task_Trigger']]

# group by groups

grouped = sub_list.groupby('Group')

#then go through the list group by group and separate

for name, group in grouped:
    print "this is" + str(name) # to follow progress


    is_full = 0 #check when a given block is full

    while is_full == 0:

        shuffled_rows = np.random.permutation(range(0,16)) #randomly permute the rows of the group

        shuffled_sub = group.iloc[shuffled_rows,:] #reorder the rows

        block_dict = defaultdict(lambda : defaultdict(list)) #create a new defaultdict

        for x in xrange(blocks):
            block_dict["block{0}".format(x)] #create each block

        for i in xrange(len(shuffled_sub)): #go through each item and place it in a block, according to constraints

            single_row = shuffled_sub.iloc[i,:] # now we have a single item from the list

            #go through each block and check the constraints

            for j in xrange(blocks): #go through all the blocks
                #check each block for conditions 
                
                group_indices = [k for k, x in enumerate(block_dict["block{0}".format(j)]['group']) if x == int(single_row.loc['Group'])] # find whether the block already contains items from that group
                noun_indices = [k for k, x in enumerate(block_dict["block{0}".format(j)]['noun']) if x == single_row.loc['Noun']] #find whether the block contains that noun
                adj_indices = [k for k, x in enumerate(block_dict["block{0}".format(j)]['adj']) if x == single_row.loc['Adj']] #find whether the block contains that adjective
                
                if len(group_indices) < 2 and len(noun_indices) < 1 and len(adj_indices) < 1: #don't want to repeat the same noun in the block or have more than two in the same group
                    #if the block matches the criteria
                    block_dict["block{0}".format(j)]['item_list'].append(int(single_row.loc['Item'])) #append the item to the item list
                    block_dict["block{0}".format(j)]['group'].append(int(single_row.loc['Group']))   #append the group to the group list
                    block_dict["block{0}".format(j)]['noun'].append(single_row.loc['Noun'])# append the noun
                    block_dict["block{0}".format(j)]['adj'].append(single_row.loc['Adj']) # append the adj
                    break
                else:
                    continue

        lengths = []
        for j in xrange(blocks):
            lengths.append(len(block_dict["block{0}".format(j)]['item_list']))
        print sum(lengths) #check their lengths to make sure they're all full
        

        if sum(lengths) == 16:
            is_full = 1 #if a block is full, stop filling it

# now that the blocks are created, need to subset the original data frame according to the block indices (in 'item') and write out to csv files
#

    for j in xrange(blocks):
    #    
        with open(filepath + "block_{0}.csv".format(j+1), 'a') as f:
    #
            index = [x-1 for x in block_dict["block{0}".format(j)]['item_list']]

            
            block = sub_list.iloc[index]
            block.to_csv(f, sep = ";", header = False, index = False)








