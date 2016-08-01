

api.endpoints <- c("professions", "backstory/questions", "backstory/answers", "itemstats", "skills")
#api.endpoints <- c("professions")


for(i in api.endpoints){
  # replace endpoint slash "/" with a dot "."
  tmp <- gsub("/", ".", i)
  # store API request
  assign(paste0(tmp, ".r"), f.call.GW2.api(i, query = list(ids="all")))
  # push json data into DF
  assign(paste0(tmp, ".static"), fromJSON(content(get(paste0(tmp, ".r")), "text"), flatten = TRUE))
}

## lapply works, but I need the names in the list
# lapply(api.endpoints, f.call.GW2.api, query = list(ids="all"))








### store everything into an .Rdata
mget(ls(pattern = ""))
"GW2-statics.RData"

glob2rx("*.r", trim.head = TRUE)

ls(pattern = "\\.r$")
