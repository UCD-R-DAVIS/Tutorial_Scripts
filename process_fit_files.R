if(!requireNamespace("remotes")) {
  install.packages("remotes")
}
remotes::install_github("grimbough/FITfileR")
library(R.utils)

floc <- 'data/strava_data/export_55674554/activities/'

gz_files <- list.files(floc,pattern = 'gz$')

library(FITfileR)
for(gz in gz_files){
  if(!file.exists(paste0(floc,stringr::str_remove(gz,'\\.gz$')))){
    gunzip(paste0(floc,gz), remove=FALSE)
  }
}

library(tidyverse)
fit_files <- list.files(floc, pattern = 'fit$')

library(pbapply)
lap_list <- pblapply(fit_files,function(f) {
  fit <- readFitFile(paste0(floc,f))
  sub <- laps(fit) %>% select(sport,timestamp,enhanced_avg_speed,
                            total_elapsed_time,total_ascent,total_descent,
                     avg_speed,avg_cadence,total_distance,avg_temperature,avg_heart_rate)
  sub},cl = 5)

library(data.table)
lap_dt <- rbindlist(lap_list)
library(lubridate)
lap_dt$timestamp <- ymd_hms(lap_dt$timestamp)
lap_dt$year <- year(lap_dt$timestamp)
lap_dt$month <- month(lap_dt$timestamp)
lap_dt$day <- day(lap_dt$timestamp)
lap_dt$date <- paste(lap_dt$year,lap_dt$month,lap_dt$day, sep = '-')
mile_per_hour_converter <- 2.236936
lap_dt$miles_per_hour <- as.numeric(lap_dt$enhanced_avg_speed) * mile_per_hour_converter
lap_dt$mile_pace <- 60 / lap_dt$miles_per_hour
lap_dt$steps_per_minute <- lap_dt$avg_cadence * 2

distance_vars <- grep('descent|ascent|distance',colnames(lap_dt),value = T)
setnames(lap_dt,distance_vars,paste0(distance_vars,'_','m'))
setnames(lap_dt,'total_elapsed_time','total_elapsed_time_s')
setnames(lap_dt,'mile_pace','minutes_per_mile')
setnames(lap_dt,'avg_heart_rate','avg_heart_rate_bpm')
setnames(lap_dt,'avg_speed','avg_speed_mps')
setnames(lap_dt,'enhanced_avg_speed','enhanced_avg_speed_mps')

lap_dt <- lap_dt %>% select(sport,year,month,day,timestamp,
                  total_distance_m,minutes_per_mile,total_elapsed_time_s,
                  avg_heart_rate_bpm,steps_per_minute,total_ascent_m,total_descent_m)

write_csv(lap_dt,file = 'data/tyler_activity_laps_10-24.csv')
