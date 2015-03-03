#analyze reaction time for behavioral data

library(effects)
library(lme4)

directory <- '/Users/masha/Dropbox/binding vs structure'

#load data 

filename <- file.path(directory, 'RT Analysis.csv')
RTs <- read.csv(filename)

#examine data to make sure everything looks correct

pairs(RTs[c('spec', 'number', 'noun_length', 'noun_freq')])
table(RTs[c('spec', 'number', 'match')])

#remove outlier reaction times, either too fast or too slow

RTs <- subset(RTs, RT < 5 & RT > 0.2 )

# plot RTs by factors

boxplot(RT~number*spec,data=RTs)

#center the numerical variables

RTs$len_c <- scale(RTs$noun_length, scale = FALSE)
RTs$TP_c <- scale(RTs$TP, scale = FALSE)
RTs$freq_c <-scale(RTs$noun_freq, scale = FALSE)

#sum contrasts

contrasts(RTs$spec) <- contr.sum(levels(RTs$spec))
contrasts(RTs$number) <- contr.sum(levels(RTs$number))
contrasts(RTs$match) <- contr.sum(levels(RTs$match))

#make sure item is treated as a factor
RTs$item <- as.factor(RTs$item)

#hierarchical model testing 

full <- lmer(log(RT) ~ spec*number*match + len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)
no_threeway <- lmer(log(RT) ~ spec*number+ spec*match + number*spec + len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)
no_match_int <- lmer(log(RT) ~ spec*number+match + len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)
no_ints <- lmer(log(RT) ~ spec+number+match + len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)                                
no_match <- lmer(log(RT) ~ spec+number + len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)       
no_word <- lmer(log(RT) ~ spec+ len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)       
no_spec <- lmer(log(RT) ~  len_c + freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)       
no_len <- lmer(log(RT)~  freq_c + (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)    
no_fixed <- lmer(log(RT) ~  (1+ spec*number| subject) +(1+ spec*number |word), data = RTs)       

anova(no_fixed, no_len, no_spec, no_word, no_match, no_ints, no_match_int, no_threeway, full)

#examine the residuals
qqnorm(resid(full))

plot(allEffects(full))