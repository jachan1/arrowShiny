library(tm)
library(wordcloud)
library(memoise)

# The list of valid books
books <- list("A Mid Summer Night's Dream" = "summer",
               "The Merchant of Venice" = "merchant",
               "Romeo and Juliet" = "romeo")

dirHor <- list("Horizontal" = 1,
               "Vertical" = 0)

dirPos <- list("Positive" = 1,
              "Negative" = 0)

getArrow <- function(startX, startY, Hor, Pos, arrowH, angle, Len){
  offset <- arrowH * tan(angle * pi / 180)
  signP <- ifelse(Pos == 1, arrowH - 0.003, 0.003)
  if(Hor == 1) {
    width = arrowH
    height = offset
    X = startX + (Pos == 1)*Len
    Y = startY
    Y2 <- Y
    Y1 <- Y - offset
    X1 <- X2 <- X - signP
  } else {
    width = offset
    height = arrowH
    X = startX
    Y = startY + (Pos == 1)*Len
    X2 <- X
    X1 <- X - offset
    Y1 <- Y2 <- Y - signP
  }
  return(list(X1 = X1, Y1 = Y1, X2 = X2, Y2 = Y2, 
              width=width, height=height, endX=X, endY=Y))
}

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (!(book %in% books))
    stop("Unknown book")
  
  text <- readLines(sprintf("./%s.txt.gz", book),
                    encoding="UTF-8")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})
