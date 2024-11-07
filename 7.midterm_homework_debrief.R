library(tidyverse)
url <- 'https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv'
df <- read_csv(url)
head(df)
df %>% 
  #filter(sport == 'running') %>%
  #filter(minutes_per_mile <=10 & minutes_per_mile >= 5) 
  filter(sport == 'running') %>%
  filter(minutes_per_mile <=10 & minutes_per_mile >= 5) %>%
  filter(total_elapsed_time_s>60) %>%
  mutate(pace = case_when(minutes_per_mile < 6 ~ 'fast',
                            minutes_per_mile >=6 & minutes_per_mile <= 8 ~ 'medium',
                            minutes_per_mile >8 ~ 'slow')) %>%
  mutate(form = ifelse(year == 2024,'new','old')) %>%
  group_by(pace,form) %>%
  summarize(mean_steps = mean(steps_per_minute)) 
  

2 + 2 * (3+3)
2 + 2 * {3+3}

pivot_wider(id_cols = 'form',names_from = 'pace',values_from = 'mean_steps')

  
  


library(tidyverse)

gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv") 
#ONLY change the "data" part of this path if necessary

head(gapminder)
#First calculates mean life expectancy on each continent. 

gapminder |> group_by(continent,year) |> summarize(avg_lifeExp = mean(lifeExp)) %>%
  ggplot(mapping = aes(x = year,y = avg_lifeExp)) + geom_path()


  ggplot(data = gapminder)




#Then create a plot that shows how life expectancy has changed over time in each continent. 
  ggplot(data = gapminder, aes(x = year,y = lifeExp)) + 
    geom_point() + 
    geom_smooth(aes(col = continent))
  


#Try to do this all in one step using pipes! (aka, try not to create intermediate dataframes)




Look at the following code and answer the following questions. What do you think the scale_x_log10() line of code is achieving? What about the geom_smooth() line of code?
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

# Create a boxplot that shows the life expectency for Brazil, China, El Salvador, Niger, and the United States, with the data points in the backgroud using geom_jitter. Label the X and Y axis with “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.
gapminder[gapminder$country %in% c('Brazil','China', 'El Salvador','Niger','United States'),]

ggplot(data = gapminder[gapminder$country %in% c('Brazil','China', 'El Salvador','Niger','United States'),], mapping = aes(x = country,y = lifeExp)) + geom_boxplot() + geom_jitter() + 
  xlab('country') + ylab('life expectancy') + 
  ggtitle('life expectancy of five countries') 


