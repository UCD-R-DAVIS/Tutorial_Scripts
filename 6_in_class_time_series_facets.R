library(tidyverse)

surveys_complete <- read_csv('data/portal_data_joined.csv') %>%
  filter(complete.cases(.))

# these are two different ways of doing the same thing
head(surveys_complete %>% count(year,species_id))
head(surveys_complete %>% group_by(year,species_id) %>% tally())

yearly_counts <- surveys_complete %>% count(year,species_id)
head(yearly_counts)

ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n)) + 
  geom_line()

ggplot(data = yearly_counts,
       mapping = aes(x = year, y = n,group = species_id)) + 
  geom_line(aes(colour = species_id)) 

ggplot(data = yearly_counts[yearly_counts$species_id%in%c('BA','DM','DO','DS'),],
       mapping = aes(x = year, y = n,group = species_id)) + 
  geom_line() +
  facet_wrap(~species_id) +
  scale_y_continuous(name = 'obs',breaks = seq(0,600,100)) +
  theme()


install.packages('ggthemes')
library(ggthemes)
library(tigris)
library(sf)
ca_counties = tigris::counties(state = 'CA',class='sf',year = 2024)
tigris::block_groups(state = 'CA',year = 2012)
ca_counties
ggplot(data=ca_counties) + 
  geom_sf(aes(fill = -ALAND)) + theme_map() +
  scale_fill_continuous_tableau()
  

