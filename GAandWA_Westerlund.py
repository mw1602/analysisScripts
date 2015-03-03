
# Bare outline by William Sakas    11/16/2012
# Finished by Masha Westerlund 12/06/2012

#this script will take a user specified file, clean it up of irrelvant markings, then count the amount of GAs and WAs for the child and the caregiver and print
#this out to an output file

#import relevant modules

import os
import re


def displayIntro(): #introduce the program to the user
    print "Hi there, I count the number of Ga's and Wa's in the aki.cha files"

def getLocations(): #this is user-specific, returns the locations of all relevant folders
    return ("C:/Documents and Settings/Masha/My Documents/Google Drive/CompLing/Homework 4/Miyata-Aki","C:/Documents and Settings/Masha/My Documents/Google Drive/CompLing/Homework 4/Miyata-Aki_cleaned",
    "C:/Documents and Settings/Masha/My Documents/Google Drive/CompLing/Homework 4/Miyata-Aki_output")

def getFileName(): #ask the user which file this script should clean for him or her
   fileName = raw_input("Which file would you like me to clean? Please do not include the file extension") #get the name of the file
   return fileName #return this information 

def getFileHandles(source_folder, output_folder, fileName): #this open the file that needs to be read and the one that needs to be written
    
    f_in = open(source_folder + "/" + fileName + ".cha", 'r')
    f_out = open(output_folder + "/" + fileName + "_out.cha", 'w')
    return (f_in,f_out)

# this function will clean up a single cha file with the handle input_handle
#   and save to the handle cleaned_handle
def cleanupOneFile (input_handle, cleaned_handle):

    # compile some regular expression patterns to look for certain things
        
    date_pat= re.compile(r'@Date:\t(.*)') # looks for the date
    speaker_pat = re.compile(r'^(\*.*)') # looks for a line that starts with an *, i.e. that is a speaker line
    bracket_pat = re.compile(r'\[.*?\]') # looks for any word that starts with a bracket

    line= input_handle.readlines()
    split_lines= line[0].split('\r')
    
    for aline in split_lines:
        date_line = re.search(date_pat, aline) #check if this line has the date
        speaker_line = re.search(speaker_pat, aline) #check if this line starts with an asterisk
        
        if date_line: # if it has the date ...
            cleaned_handle.write(aline + '\n') # then print the line to the output file along with a newline character

        if speaker_line: # if it starts with an asterisk
            #now we want to print everything on the line that is speech (i.e. everything not in brackets)
            #to do this we will use re.sub, which replaces a matched pattern
            cleaned_line = re.sub(bracket_pat, "", aline) #replace brackets with nothing
            cleaned_handle.write(cleaned_line + '\n')
                                
    input_handle.close() #close the files that you're done with 
    cleaned_handle.close()

def countGAandWAs(cleaned_handle,output_handle):

    #first define the holder variables to increment

    child_GAs = 0;
    child_WAs = 0;
    care_GAs = 0;
    care_WAs = 0;

    #now compile some RegEx patterns to use for counting

    child_pat = re.compile(r'^(\*CHI:)')
    caregiver_pat = re.compile(r'^(\*AMO:)')
    ga_pat = re.compile(r'\sga\s', re.IGNORECASE)
    wa_pat = re.compile(r'\swa\s', re.IGNORECASE)

    lines = cleaned_handle.readlines() #read the cleaned file

    for line in lines: #go line by line
        if re.search(child_pat, line): #if this is a child line
            GAs = re.findall(ga_pat, line) #then find the GAs
            WAs = re.findall(wa_pat, line)#and the WAs

            if GAs: #if there are some
                child_GAs = child_GAs + len(GAs) #count how many there were in findall and add this to the increment variable
            if WAs:
                child_WAs = child_WAs + len(WAs)

        if re.search(caregiver_pat, line): #if this is a caregiver line
            GAs = re.findall(ga_pat, line) #then find the GAs
            WAs = re.findall(wa_pat, line) #and the WAs

            if GAs:
                care_GAs = care_GAs + len(GAs) #count how many there were and add this to the count
            if WAs:
                care_WAs = care_WAs + len(WAs)

    date_line = lines[0].rstrip('\n') #get only the date line
    date = date_line.split() #split it because we don't want the other random stuff, just the actual date

    output_handle.write(date[1] + '\t') #write only the actual date to the output file
    output_handle.write(str(child_GAs) + '\t') #then write the other counts in order to the output file
    output_handle.write(str(child_WAs) + '\t')
    output_handle.write(str(care_GAs) + '\t')
    output_handle.write(str(care_WAs) + '\t')
    print(child_GAs, child_WAs, care_GAs, care_WAs) #also print them out to the window in case the user wants to see them right away 
                        
        
def main():
    displayIntro()
    # Get folders for source files and for cleaned files
    #   Assume they're already created and that the source files
    #   are already in the source location, but the cleaned files
    #   location is empty.
    
    IN, CLEANED, OUT = getLocations()

    #ask user which file they would like cleaned

    fileName = getFileName()


    input_handle, cleaned_handle = getFileHandles(IN, CLEANED, fileName) #get the file handles for all the relevant files
    
    
    cleanupOneFile (input_handle, cleaned_handle) #clean up the file

    cleaned_handle, output_handle = getFileHandles(CLEANED, OUT, fileName) #get the file handle for the output file


    #    
    countGAandWAs(cleaned_handle, output_handle) #count the GAs and WAs in the cleaned up file

    
main()
