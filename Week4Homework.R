#PART 1
#Create a tibble named surveys from the portal_data_joined.csv file.

library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")




#PART 2
#Subset surveys using Tidyverse methods to keep rows with weight 
#between 30 and 60, and print out the first 6 rows.
surveys %>% 
  filter(weight > 30 & weight < 60) %>% head()
#or weight %in% 30:60

#PART 3a
#Create a new tibble showing the maximum weight for each species
# + sex combination and name it biggest_critters.
#HINT: it’s easier to calculate max if
# there are no NAs in the dataframe…
biggest_critters <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  summarise(max_weight = max(weight))

#PART 3b
# Sort the tibble to take a look at the biggest and 
# smallest species + sex combinations.
biggest_critters %>% arrange(max_weight) %>% head()

biggest_critters %>% arrange(desc(max_weight)) %>% head()
# or arrange(-max_weight)

#PART 4
#Try to figure out where the NA weights are concentrated 
#in the data- is there a particular species, 
#taxa, plot, or whatever, where there are lots of NA values? 
#There isn’t necessarily a right or wrong answer here, 
#but manipulate surveys a few different ways to explore this. 
#Maybe use tally and arrange here.

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(species) %>% 
  tally() %>% 
  arrange(desc(n))

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(taxa) %>% 
  tally() %>% 
  arrange(desc(n))

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(plot_id) %>% 
  tally() %>% 
  arrange(desc(n))

#PART 5
#Take surveys, 
#remove the rows where weight is NA 
#and add a column that contains the average weight of 
#each species+sex combination to the full surveys dataframe. 
#Then get rid of all the columns except for species, sex, 
#weight, and your new average weight column. 
#Save this tibble as surveys_avg_weight.
#This table has the same number of rows as the original!
surveys_avg_weight <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  mutate(avg_weight = mean(weight)) %>% 
  select(species_id, sex, weight, avg_weight)
#group_by multiple groups makes groups of every combo

surveys_avg_weight

#Difference between mutate and summarize -- 
#what if we wanted a mini table?
mini_avg_weight <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  summarize(avg_weight = mean(weight)) 

mini_avg_weight



#PART 6 
# Take surveys_avg_weight and add a new column 
#called above_average that contains logical values 
#stating whether or not a row’s weight is above average 
#for its species+sex combination 
#(recall the new column we made for this tibble).
surveys_avg_weight <- surveys_avg_weight %>% 
  mutate(above_average = weight > avg_weight)
#ifelse(weight > avg_weight, T, F)

surveys_avg_weight

surveys_avg_weight %>% ungroup %>% count(above_average)





