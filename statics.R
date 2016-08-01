## all endpoints to query
api.endpoints <- c("professions", "backstory/questions", "backstory/answers", "itemstats", "skills", "specializations")

## loop through endpoints, store reply in $i.r, store result in $i.static
for(i in api.endpoints){
  # replace endpoint slash "/" with a dot "."
  tmp <- gsub("/", ".", i)
  # store API request
  assign(paste0(tmp, ".r"), f.call.GW2.api(i, query = list(ids="all")))
  # push json data into DF
  assign(paste0(tmp, ".static"), fromJSON(content(get(paste0(tmp, ".r")), "text"), flatten = TRUE))
}

# ## lapply works, but I lists of DFs are a special kind of hell...
# test <- lapply(api.endpoints, f.call.GW2.api, query = list(ids="all"))
# names(test) <- api.endpoints
# test2 <- lapply(test, function(x){fromJSON(content(x, "text"), flatten = TRUE)})

# # matches everything NOT ".r$"
# ls(pattern = "[^\\.r]$")

### store the result DFs into an .Rdata
save(list = ls(pattern = "\\.static$"), file = "GW2-statics.RData")





