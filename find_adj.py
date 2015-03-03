#script to extract bigrams from the coca database, with the authentification information removed

import os, psycopg2, csv

conn = psycopg2.connect(authentification_info)

cursor = conn.cursor()

if sys.platform.startswith('win32'): # for cross-platform compatibility across laptop and work computer
    filename = 'C:\Users\dailyuser\Dropbox\Dissertation Proposal\\final_nouns.csv'
else:
    filename = os.path.expanduser('~/My Documents/My Dropbox/Dissertation Proposal/nouns.csv')

l = list(csv.DictReader(open(filename,'rU')))
outfile = open('bigrams_finalnouns.csv', 'wb') #write results out to file
wr = csv.writer(outfile, quoting=csv.QUOTE_ALL)

for row, phrase in enumerate(l) :

    noun = phrase['noun']
    print noun # to keep track of progress

    #get all bigrams in which the noun is the second word and the first word is an adjective
    query = "SELECT lex1, lex2, bigrams.freq FROM coca_bigrams as bigrams, coca_lex AS lex1, coca_lex AS lex2 WHERE lex1.pos like 'j%%'  and lex2.word = %s and lex1.wID = bigrams.w1 and lex2.wID = bigrams.w2"
    cursor.execute(query, (noun,))
    results = cursor.fetchall()

    for item in results: #write results out to file
        
        item_line = [item[0].split(',')[1],item[1].split(',')[1],item[2]]

        if len(results) == 0:
                    wr.writerow(0)
        else:
                    wr.writerow(item_line)

myfile.close()
