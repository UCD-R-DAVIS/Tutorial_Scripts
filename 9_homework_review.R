library(tidyverse)


surveys <- read.csv("data/portal_data_joined.csv")

#1 Using a for loop, print to the console the longest species 
#name of each taxon. Hint: 
#the function nchar() gets you the number of characters in a string.

for(i in unique(surveys$taxa)){
  mytaxon <- surveys %>% filter(taxa == i)
  #equivalent to answer key
  #mytaxon <- surveys[surveys$taxa == i,]
  print(i)
  
  #option 1
  #use filter and select on the original dataframe
  maxlength <- max(nchar(myspecies))
  mytaxon %>% filter(nchar(species) == maxlength) %>% 
    select(species) %>% 
    unique()
  #equivalent to answer key
  #mytaxon[nchar(mytaxon$species) == max(nchar(mytaxon$species)),] %>% 
  #select(species) %>% unique()
  
  #option 2
  #use the "which" function on a vector of unique species
  myspecies <- unique(mytaxon$species)
  myindices <- which(nchar(myspecies) == max(nchar(myspecies)))
  print(myspecies[myindices])
  
  #option 3
  #use ifelse statement to generate vector of longest species names
  printspecies <- ifelse(nchar(myspecies)==maxlength, myspecies, "")
  printspecies <- printspecies[nchar(printspecies)>0]
  print(printspecies)
  
}

mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#part 2
#Use the map function from purrr to print the max of
#each of the following columns: 
#“windDir”,“windSpeed_m_s”,“baro_hPa”,“temp_C_2m”,
#“temp_C_10m”,“temp_C_towertop”,“rel_humid”,
#and “precip_intens_mm_hr”.
mycols <- mloa %>% 
  select("windDir","windSpeed_m_s","baro_hPa","temp_C_2m",
         "temp_C_10m","temp_C_towertop","rel_humid", 
         "precip_intens_mm_hr")
mycols %>% map(max, na.rm = T)

#part 3
#Make a function called C_to_F that converts Celsius to Fahrenheit. 
#Hint: first you need to multiply the Celsius temperature by 1.8, 
#then add 32. Make three new columns called 
#“temp_F_2m”, “temp_F_10m”, and “temp_F_towertop” by 
#applying this function to columns 
#“temp_C_2m”, “temp_C_10m”, and “temp_C_towertop”. 

C_to_F <- function(x){
  x * 1.8 + 32
}

#you can use mutate
mloa <- mloa %>%
  mutate(
    temp_F_2m = C_to_F(temp_C_2m),
    temp_F_10m = C_to_F(temp_C_10m),
    temp_F_towertop = C_to_F(temp_C_towertop)
  )

#alternatively, you can define a new column using the dollar sign notation
mloa$temp_F_2m <- C_to_F(mloa$temp_C_2m)
mloa$temp_F_10m <- C_to_F(mloa$temp_C_10m)
mloa$temp_F_towertop <- C_to_F(mloa$temp_C_towertop)


#Bonus: can you do this by using map_df? 
#Don’t forget to name your new columns “temp_F…” and not “temp_C…”!
newmloa <- mloa %>% select(c("temp_C_2m", 
                             "temp_C_10m", 
                             "temp_C_towertop")) %>% 
  map_df(C_to_F) %>% 
  rename("temp_F_2m"="temp_C_2m", 
         "temp_F_10m"="temp_C_10m", 
         "temp_F_towertop"="temp_C_towertop") %>% 
  cbind(mloa)

#alternatively, use bind_cols from dplyr instead of cbind,
newmloa <- mloa %>% select(c("temp_C_2m", 
                             "temp_C_10m", 
                             "temp_C_towertop")) %>% 
  map_df(C_to_F) %>% 
  rename("temp_F_2m"="temp_C_2m", 
         "temp_F_10m"="temp_C_10m", 
         "temp_F_towertop"="temp_C_towertop") %>% 
  bind_cols(mloa)

#challenge
#Use lapply to create a new column of the surveys dataframe that 
#includes the genus and species name together as one string.
surveys <- surveys %>% mutate(genusspecies =
                                lapply(1:length(surveys$species), function(i){
                                  paste0(surveys$genus[i], " ", surveys$species[i])
                                }))

#equivalent to answer key version
surveys$genusspecies <- lapply(1:length(surveys$species), function(i){
  paste0(surveys$genus[i], " ", surveys$species[i])
})
