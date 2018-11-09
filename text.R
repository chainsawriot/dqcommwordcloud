require(quanteda)
require(stringr)

titles <- readRDS('titles.RDS')

tcorpus <- corpus(str_replace_all(titles, "\\[.+\\]", ""))
tdfm <- dfm(tcorpus, remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE)
tdfm <- dfm_select(tdfm, tm::stopwords('en'), selection = 'remove')
tdfm_tfidf <- dfm_weight(tdfm, type = 'tfidf')

#cols <- sample(colors()[2:128], 5)
#saveRDS(cols, "goodcols.RDS")
#cols <- readRDS('goodcols.RDS')
cols <- c('#dba751', '#004422', '#16779a')
##devtools::install_github("chainsawriot/wordcloudrr")
require(wordcloudrr)

features <- topfeatures(tdfm_tfidf, n = 200)
#png("test.png", width = 1000, height = 1000)
textplot_wordcloud(tdfm_tfidf, max.words = 110, rot.per = .1, colors = cols, random.order = FALSE)
dev.off()

cc <- cols[factor(cut(features, c(0 , 40, 300 , Inf)))]

wordcloudrr(names(features), features, scale=c(0.1, 0.01), cols= cc, width = 600, height = 600, rot_per = 0.2, shape = "star")

