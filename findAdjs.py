import csv
from collections import defaultdict
from collections import Counter

#findAdjs(triplets, bigrams)
#takes in a list of triplets and finds bigrams that contain the same adjective
#for all members of the triplet, i.e. for the triplet (building/house/mansion, looks for cases of big building/big house/big mansion)

adj = defaultdict(list) # dictionary organized by adjectives
noun = defaultdict(list) #dictionary organized by nouns 
old_bigrams = defaultdict(list) #dictionary organized by bigrams
bigrams = defaultdict(list)
triplet_list = []

with open('bigrams_morenouns.csv','rU') as f_data: #read all bigram information into various dictionaries
     l = csv.reader(f_data,quoting=csv.QUOTE_ALL)
     for phrase in l:
#      	print phrase
     	a = phrase[0]
     	n = phrase[1]
     	f = phrase[2]
     	triplet_list.append((a,n,f))
     # 	adj[a].append((n,f))
#      	noun[n].append((a,f))
     	old_bigrams[(a,n)].append(f)
     	
     f_data.closed
     
#now get adjective frequencies 
adj_freq = defaultdict(list)

with open('more_nouns_adjs_freqs.csv','rU') as f_data: #read all adjective frequencies
	 l = csv.reader(f_data,quoting=csv.QUOTE_ALL)
	 for phrase in l:
		a = phrase[0]
		f = phrase[1]
		adj_freq[a].append(f)
	 f_data.closed

listcomp = [i[:2] for i in triplet_list]
listcomp = Counter(listcomp)
listcomp = [key for key, value in listcomp.iteritems() if value >= 2]  

for triplet in triplet_list:
	bigram = triplet[:2]
	
	if bigram in listcomp:
		freq = sum(map(int,old_bigrams.get(bigram)))
		adj[bigram[0]].append((bigram[1], freq))
		noun[bigram[1]].append((bigram[0],freq))
		bigrams[(bigram[0], bigram[1])].append(freq)
		
	else:
		adj[bigram[0]].append((bigram[1], triplet[2]))
		noun[bigram[1]].append((bigram[0],triplet[2]))
		bigrams[(bigram[0], bigram[1])].append(triplet[2])
		

filen = 'more_triplets.csv' # read in the triplets
triplets = list(csv.DictReader(open(filen, 'rU')))
myfile = open('filtered_bigrams_more_nouns.csv', 'wb')
wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
for row, phrase in enumerate(triplets):
	superord = phrase['super']
	basic = phrase['basic']
	sub = phrase['sub']
	adjectives = noun.get(superord)
	my_list = []

	for adjective in adjectives:
		freq = adj_freq.get(adjective[0])

		if bigrams.get((adjective[0], basic)) > 0 and bigrams.get((adjective[0], sub)) > 0:
			item_line = [adjective[0], freq[0], superord, bigrams.get((adjective[0], superord))[0], float(bigrams.get((adjective[0], superord))[0])/float(freq[0]), basic, bigrams.get((adjective[0], basic))[0], float(bigrams.get((adjective[0], basic))[0])/float(freq[0]),sub, bigrams.get((adjective[0], sub))[0],float(bigrams.get((adjective[0], sub))[0])/float(freq[0])]
			wr.writerow(item_line)

				

		
		

	

	