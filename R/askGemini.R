#' This function is to ask Gemini a question and get the answer from it.
#' @param text character, the question
#' @param key the API key for Gemini.
#' @param returnFull logical, whether to return a `response` object. Default is FALSE.
#' @param verbose logical, whether to show the respoding details of the server. Default is FALSE.
#' @details
#' askGemini works dependent on the Gemini API, which requires the user to create their own API key.
#' (1) go to this https://ai.google.dev/ address and click `Get API key in Google AI Studio`;\cr
#' (2) Then select `Get API key`;\cr
#' (3) Consent the agreement;\cr
#' (4) Click Create API key;\cr
#' (5) Copy this API key and define it into `~/.Renviron` file in bash terminal by
#' `echo 'GEMINIKEY=YOUR_API_KEY' >> ~/.Renviron`, and remember replace `YOUR_API_KEY`
#' by your real API key that you just created.\cr
#' Currently, Gemini API is allowed in 60+ countries, which do not include
#' mainland China, Germany, etc. If you would like to use this you need a proxy,
#' which is yet to be implemented.
#'
#' @import httr
#' @examples
#' \dontrun{
#' # If your key is configured in ~/.Renviron file then you don't need to provide key option in the function.
#'
#' # Ask Gemini an English question
#' askGemini("Who are you")
#'
#' # Ask Gemini a Chinese question
#' askGemini("你是谁")
#'
#' # Ask Gemini a French question
#' askGemini("Qui es-tu")
#'
#' # Ask Gemini a Spanish question
#' askGemini("Quién eres")
#'
#' key = 'YOUR_API_KEY'  # Replace it by your real Gemini API key
#' # Ask Gemini English questions
#' askGemini("Who are you", key)
#' }
#' @export
# This function will be modified
askGemini = function(text, key = NULL, returnFull = FALSE, verbose = FALSE){
  key = .checkKey(key, "GEMINIKEY", 39)
  url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?'
  urlKey = paste0(url, "key=", key)

  # Define JSON data
  json_data = paste0('{"contents":[{"parts":[{"text":"', text, '"}]}]}')

  # Set request headers
  headers = c('Content-Type' = 'application/json')

  # Send POST request
  response = httr_POST(url = urlKey, config = add_headers(headers),
                       body = json_data,
                       verbose = verbose)

  # return
  if(!returnFull){
    res = content(response)$candidates[[1]]$content$parts[[1]]$text
    class(res) = "AI_response"
    return(res)
  } else {
    return(response)
  }
}
