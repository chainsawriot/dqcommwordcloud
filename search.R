## ### Sys req: sudo apt-get install libpoppler-cpp-dev

## devtools::install_github("ropensci/fulltext")
## require(fulltext)

## res <- ft_search(query ='media deliberation', from ='crossref', limit = 1000, scopusopts = list(key = 'c3a3a9f542e6c835b69cea67e538dd2f'))

## z <- ft_get(res$crossref$data$doi[1:100])

## devtools::install_github('chartgerink/osfr')

## require(osfr)

## login()



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


