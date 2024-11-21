#Let’s look at some real data from Mauna Loa to try to format and plot. 
#These meteorological data from Mauna Loa were collected every minute for 
#the year 2001. This dataset has 459,769 observations for 9 different 
#metrics of wind, humidity, barometric pressure, air temperature, and 
#precipitation. 
#Download this dataset here. 
library(tidyverse)
mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#Save it to your data/ folder. 
#Alternatively, you can read the CSV directly from the R-DAVIS Github: 
#mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#Use the README file associated with the Mauna Loa dataset to determine in what time zone the data are reported, 
#and how missing values are reported in each column. 
#1 With the mloa data.frame, remove observations with missing values in rel_humid, 
# temp_C_2m, and windSpeed_m_s. 

mloa <- mloa %>% 
  filter(windSpeed_m_s > 0 & temp_C_2m > 0 & rel_humid > 0)


# Generate a column called “datetime” using the year, month, day, hour24, and min columns. 
library(lubridate)

paste(mloa$year,mloa$month,mloa$day,sep ='-')


mloa <- mloa %>% mutate(datetime = ymd_hm(paste(paste(year,month,day,sep = '-'),
                                        paste(hour24,min,sep = ':'))))

# Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time (HINT: look at the lubridate function called with_tz()).

mloa <- mloa %>% mutate(datetime_hst = with_tz(as_datetime(datetime,tz = 'UTC'),'HST')) 


# Then, use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetimeLocal columns. 
#(HINT: Look at the lubridate functions called month() and hour()). 


mloa2 <- mloa %>% mutate(hour_hst = hour(datetime_hst)) %>% group_by(hour_hst,month) %>%
  summarize(mean_hourly_temp = mean(temp_C_2m))


#Finally, make a ggplot scatterplot of the mean monthly temperature, 
#with points colored by local hour.

library(khroma)
ggplot(data = mloa2,aes(x = month(month,label = T,abbr = T),y = mean_hourly_temp,color = hour_hst)) + 
  geom_point() + 
  scale_color_romaO() + 
  theme_bw() + 
  theme(axis.title.x = element_blank(),axis.ticks = element_blank())
  
  