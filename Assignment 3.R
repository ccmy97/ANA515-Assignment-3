install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot2")
install.packages("stringr")
library("tidyverse")
library("dplyr")
library("ggplot2")
library("stringr")

setwd("C:/Users/cmy59/Documents/")
getwd()
stormdata <- read_csv("abc.csv")

myvars <- c("BEGIN_DATE_TIME","END_DATE_TIME","EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
newdata <- stormdata[myvars]
head(newdata)

arrange(newdata,STATE)

#4 missing
newdata$STATE <- str_to_title(newdata$STATE)


#5
newdata <- filter(newdata, CZ_TYPE == 'C')
newdata <- select(newdata, -CZ_TYPE)


#6(review)
newdata$STATE_FIPS <- str_pad(newdata$STATE_FIPS, width=3, side = "left", pad = "0")
newdata$CZ_FIPS <- str_pad(newdata$CZ_FIPS, width=3, side ="left", pad ="0")
unite(newdata, col="fips", c(STATE_FIPS,CZ_FIPS), sep="")

#7
newdata <- rename_all(newdata,tolower)

#8
us_state_info <- data.frame(state = state.name, region=state.region, area=state.area)

#9
Newset <- data.frame(table(newdata$state))
head(Newset)

Newset1 <- rename(Newset,c("state"="Var1"))
Newset1merge <- merge(x=Newset1, y=us_state_info, by.x="state", by.y="state")
head(Newset1merge)
view(Newset1merge)

#10
stormplot <- ggplot(Newset1merge, aes(x=area, y=Freq))+geom_point(aes(color=region)) + labs (x= "Land Area (Square Miles)", y= "# of storm events in 1997")
stormplot