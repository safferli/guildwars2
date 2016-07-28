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
wd <- "/home/csafferling/Documents/github/guildwars2"
setwd(wd)

## set your own GW2 key in your ~/.Renviron 
# http://blog.revolutionanalytics.com/2015/11/how-to-store-and-use-authentication-details-with-r.html
# option 4: In a .Renviron file
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

# TODO: make a package?
# https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html


##
## Characters
##

# https://wiki.guildwars2.com/wiki/API:2/characters

char.r <- f.call.GW2.api("characters", query = list(page="0"))
# status_code(r)
# content(r, "text")

characters <- fromJSON(content(char.r, "text"), flatten = TRUE) #%>% as_tibble()

# age (number) - The amount of seconds this character was played.

# 
# r <- httr::GET(paste0(GW2.api.base, GW2.api.endpoint, "?ids=all"), add_headers(Authorization = paste0("Bearer ", GW2.key)))
# content(r, "text")


### Profession information
prof.r <- f.call.GW2.api("professions", query = list(ids="all"))

professions <- fromJSON(content(prof.r, "text"), flatten = TRUE)



gg <- ggplot()+
  geom_bar(data = characters, aes(x=race, y=level, fill=profession), stat = "identity")
gg





