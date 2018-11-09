require(rvest)

require(glue)

for (z in seq(from = 720, to = 10000, by = 10)) {
    read_html(glue("https://scholar.google.de/scholar?start={val}&q=media+deliberation&hl=en&as_sdt=0,5", val = z)) -> x

    x %>% html_nodes('h3') %>% html_text -> res
    titles <- c(titles, res)
    print(length(titles))
    Sys.sleep(10)
}


install.packages("RSelenium")
require(RSelenium)
rD <- rsDriver(browser = 'firefox')

remDr <- rD[["client"]]

remDr$navigate("https://scholar.google.de/scholar?start=690&q=media+deliberation&hl=en&as_sdt=0,5")


extract_t <- function(x) {
    x$getElementText()[[1]]
}

titles <- c()

for (i in 1:1000) {
    Sys.sleep(5)
    h3s <- remDr$findElements(using = "css", "h3")
    #h3s[[1]]$getElementText()[[1]]
    res <- sapply(h3s, extract_t)
    titles <- c(titles, res)
    print(length(titles))
    nextLink <- remDr$findElements(using = "link text", "Next")
    nextLink[[1]]$clickElement()
}

unique(unlist(titles)) -> titles

saveRDS(titles, 'titles.RDS')


