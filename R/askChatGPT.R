#' This function is to ask ChatGPT a question and get the answer from it.
#' @param text character, the question
#' @param key the API key for ChatGPT
#' @param model The model to use, "gpt-3.5-turbo"
#' @param textForSystem character, the extra information for system
#' @param moreHeaders NULL
#' @param returnFull logical, whether to return a `response` object. Default is FALSE.
#' @param verbose logical, whether to show the respoding details of the server. Default is FALSE.
#' @details See this https://platform.openai.com/docs/api-reference for more details
#' @import httr
#' @import jsonlite
#' @examples
#' \dontrun{
#' debugonce(askChatGPT)
#' askChatGPT(text = "Compose a poem that explains the concept of recursion in programming.",
#' textForSystem = "You are a poetic assistant, skilled in explaining complex programming concepts with creative flair.")
#' )
#' }
#' @export
# This function will be modified
askChatGPT = function(text,
                      key = NULL,
                      model = "gpt-3.5-turbo",
                      textForSystem = NULL,
                      moreHeaders = c(),
                      returnFull = FALSE, verbose = FALSE){
  if(missing(text)) stop("text must be provided.")
  key = .checkKey(key, "OPENAI_API_KEY", 51)
  url = 'https://api.openai.com/v1/chat/completions'

  # input data
  if(is.null(textForSystem)) {
    message = list(list(role = "user", content = text))
  } else {
    message = list(list(role = "system", content = textForSystem),
                   list(role = "user", content = text))
  }
  data = list(model = model, messages = message)

  # Define JSON data
  # json_data = paste0('{"contents":[{"parts":[{"text":"', text, '"}]}]}')
  json_data = toJSON(data, auto_unbox = T, pretty = F)

  # Set request headers
  headers = c(c('Content-Type' = 'application/json',
              'Authorization' = paste('Bearer', key)),
              moreHeaders)

  # Send POST request
  response = httr_POST(url = url, config = add_headers(headers),
                       body = json_data,
                       verbose = verbose)

  results = content(response)

  # return
  if(!returnFull){
    if(!is.null(results$error$code) && results$error$code == "insufficient_quota"){
      stop(results$error$message)
    } else{
      res = results$choices[[1]]$message$content
      if(!is.null(res)){
        class(res) = "AI_response"
      } else {
        stop("NULL is returned. Try returnFull = FALSE and verbose = FALSE to find out the reason.")
      }
    }
    return(res)
  } else {
    return(response)
  }
}


