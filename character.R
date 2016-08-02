rm(list = ls()); gc(); gc()
# options(java.parameters = "-Xmx4096m")#8192
# options(java.parameters = "-XX:-UseConcMarkSweepGC")
# options(java.parameters = "-XX:-UseGCOverheadLimit")
options(bitmapType='cairo')
options(scipen = 999)

library(httr)
library(jsonlite)
library(dplyr)
#library(tidyr)
library(ggplot2)

# Define your workspace: "X:/xxx/"
#wd <- "D:/github/statistics101/"
wd <- path.expand("~/Documents/github/guildwars2")
setwd(wd)

## set your own GW2 key in your ~/.Renviron 
# http://blog.revolutionanalytics.com/2015/11/how-to-store-and-use-authentication-details-with-r.html
GW2.key <- Sys.getenv("GW2.key")

## API call wrapped in a function
f.call.GW2.api <- function(endpoint, version = "v2", key = GW2.key, ...){
  
  # API address
  GW2.api.base <- "https://api.guildwars2.com/"
  
  # set up the API query
  GW2.api <- httr::modify_url(
    # pagination goes via query = "page=0" in ... 
    GW2.api.base, path = list(version, endpoint), ...
  )
  
  # call API
  r <- httr::GET(GW2.api, add_headers(Authorization = paste0("Bearer ", key)))
  # return API call
  return(r)
}

## pull all static API calls first
if(!file.exists("GW2-statics.RData")){
  source(statics.R)
} else {
  load("GW2-statics.RData")
}








##
## Characters
##

# https://wiki.guildwars2.com/wiki/API:2/characters

char.r <- f.call.GW2.api("characters", query = list(page="0"))
characters <- fromJSON(content(char.r, "text"), flatten = TRUE) #%>% as_tibble()
# age (number) - The amount of seconds this character was played.




# backstory

f.get.backstory <- function(charname, char.dta = characters) {
  
  # get backstory options of character
  bksty <- char.dta %>% 
    filter(name == charname) %>% 
    select(backstory) %>% 
    unlist() %>% 
    unname()
  
  # get respective answers
  answers <- backstory.answers.static %>% 
    filter(id %in% bksty)
  
  # paste all journal entries into one string
  story <- paste0(
    "I am ", charname, ".", "\n\n",
    answers %>% select(journal) %>% unlist() %>% paste(., collapse = " ")
  )
  
  # change html tags to escape strings
  story <- gsub("<br>", "\n", story)
  
  # return story
  return(story)
}


cat(
  f.get.backstory("Ghodiva")
)





# characters by race
ggplot()+
  geom_bar(data = characters, aes(x=race, y=level, fill=profession), stat = "identity")

# characters by profession
ggplot()+
  geom_bar(data = characters, aes(x=profession, y=level, fill=race), stat = "identity")





