getwd()
file_loc <- 'data/portal_data_joined.csv'
surveys <- read.csv(file_loc)
nrow(surveys)
ncol(surveys)
dim(surveys)

str(surveys)

class(surveys)
summary(surveys$record_id)
summary(surveys)

str(surveys)

head(surveys)
tail(surveys)
head(surveys,n = 3)

summary(object = surveys)
summary.data.frame(surveys)
?summary.data.frame

dim(surveys)

surveys[1,5]

# first 5 rows
surveys[1:5,]

surveys[c(1,5,24, 3001),]

surveys[,1]

surveys[,1:5]

dim(surveys[,1:5])

dim(surveys[1])

surveys['record_id']

colnames(surveys)

cols_to_grab = c('record_id','year','day')
cols_to_grab
surveys[cols_to_grab]
head(surveys)
dim(surveys)
head(surveys[1:10,])
dim(surveys[c('record_id','year','day')])
head(surveys,1)

tail(surveys)
head(surveys)
surveys[1:6,]


surveys[,1]
head(surveys[1])
head(surveys[,1])

surveys[1:3,]

1:10
surveys[1:10,]

surveys[,1:3]

surveys[1:3,1:3]

surveys[c(1,4,10),c(2,4,6)]

surveys[,-1]

surveys[-1,]

surveys[-c(7:nrow(surveys)),]
nrow(surveys)==34786
head(surveys)

head(surveys[c("genus","species")])
head(surveys[["genus","species"]])

head(surveys['genus',])
head(surveys[,'genus'])
str(surveys)

surveys$plot_id
class(surveys$hindfoot_length)





install.packages('tidyverse')
library(tidyverse)
?read_csv
t_surveys <- read_csv('data/portal_data_joined.csv')
class(t_surveys)
t_surveys

surveys[,1]
t_surveys[,1]
