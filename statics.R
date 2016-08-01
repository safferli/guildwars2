
### professions
prof.r <- f.call.GW2.api("professions", query = list(ids="all"))
professions <- fromJSON(content(prof.r, "text"), flatten = TRUE)

### backstory
back.q.r <- f.call.GW2.api("backstory/questions", query = list(ids="all"))
back.a.r <- f.call.GW2.api("backstory/answers", query = list(ids="all"))
backstory.questions <- fromJSON(content(back.q.r, "text"), flatten = TRUE)
backstory.answers <- fromJSON(content(back.a.r, "text"), flatten = TRUE)

### itemstats
itemstats.r <- f.call.GW2.api("itemstats", query = list(ids="all"))
itemstats <- fromJSON(content(itemstats.r, "text"), flatten = TRUE)








### store everything into an .Rdata
mget(ls(pattern = ""))
"GW2-statics.RData"

glob2rx("*.r", trim.head = TRUE)

ls(pattern = "\\.r$")
