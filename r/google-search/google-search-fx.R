
get_search_url <- function(search.term, language = 'de',  domain = '.ch', quotes=TRUE, n.pages=1){
  search.term <- gsub(' ', '%20', search.term)
  
  if(isTRUE(quotes)) search.term <- paste('%22', search.term, '%22', sep='') 
  
  google.url <- paste('http://www.google', domain, '/search?','hl=', language,'&q=',
                        search.term, sep='')
  
  if(n.pages>1){
    return(c(google.url, paste0(google.url, '&ei=q-W9W-2MBoTCwALs5aPwBg&start=', (1:(n.pages-1))*10, '&sa=N')))
  }else{
    return(google.url)
  }
}

get_google_hits <- function(google.url, raw=T, drop.recursives=F) {
  doc <- getURL(URLencode(google.url), .opts=curlOptions(followlocation=TRUE, cookiefile="nosuchfile"))
  html <- htmlTreeParse(doc, useInternalNodes = TRUE, error=function(...){})
  nodes <- getNodeSet(html, "//h3[@class='r']//a")
  raw.refs <- sapply(nodes, function(x) x <- xmlAttrs(x)[["href"]])
  
  if(isTRUE(drop.recursives)) raw.refs <- raw.refs[!grepl('\\/search\\?q\\=', raw.refs)]
  
  if(isTRUE(raw)){
    return(raw.refs)
    }else{
    clean.refs <- gsub('(\\/url\\?q\\=)|(\\&sa.*)', '', raw.refs) %>% 
      sapply(., function(x) URLdecode(URLdecode(x)))
    return(clean.refs)
  }

}