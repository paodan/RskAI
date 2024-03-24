
#' Convert text to an audio file
#' @param text character, the question
#' @param key the API key for OpenAI
#' @param model The model to use, one of c("tts-1", "tts-1-hd")
#' @param voice one of c("alloy", "echo", "fable", "onyx", "nova", "shimmer")
#' @param response_format one of c("mp3", "opus", "aac", "flac", "wav", "pcm")
#' @param moreHeaders NULL
#' @param output output file for audio
#' @param speed ranging from 0.25 to 4.0. Default is 1.0
#' @param verbose logical, whether to show the respoding details of the server. Default is FALSE.
#' @import httr
#' @import jsonlite
#' @importFrom tools file_path_sans_ext
#' @export
#' @examples
#' \dontrun{
#'
#' text2Speach("Compose a poem that explains the concept of recursion in programming.")
#' text2Speach("Convert this into an English monologue.",
#'              output = "English.mp3")
#' text2Speach("把这个转换成中文普通话.", voice = "nova",
#'              output = "Chinese.mp3")
#‘ text2Speach("Convierte esto al habla española.", output = "Spanish.mp3")
#' text2Speach("Convertissez ceci en un monologue anglais", output = "Franch.mp3")
#' text2Speach("把这个English conversation转换成中文对话.", voice = "nova",
#'              output = "Mix.mp3")
#' }
#'
text2Speach = function(text,
                       key = NULL,
                       model = c("tts-1", "tts-1-hd"),
                       voice = c("alloy", "echo", "fable", "onyx", "nova", "shimmer"),
                       response_format = c("mp3", "opus", "aac", "flac", "wav", "pcm"),
                       moreHeaders = c(),
                       output = "speech", speed = 1, verbose = FALSE){
  if(missing(text)) stop("text must be provided.")
  model = match.arg(model)
  voice = match.arg(voice)
  response_format = match.arg(response_format)
  speed = .checkSpeed(speed)
  key = .checkKey(key, "OPENAI_API_KEY", 51)
  url = 'https://api.openai.com/v1/audio/speech'

  # input data
  data = list(model = model, input = text, voice = voice, response_format = response_format)

  # Define JSON data
  # json_data = paste0('{"contents":[{"parts":[{"text":"', text, '"}]}]}')
  json_data = toJSON(data, auto_unbox = T, pretty = F)

  # Set request headers
  headers = c(c('Content-Type' = 'application/json',
                'Authorization' = paste('Bearer', key)),
              moreHeaders)
  headers = input2Headers(headers)

  # Send POST request
  response = httr_POST(url = url, config = headers,
                       body = json_data,
                       verbose = verbose)

  output = paste0(file_path_sans_ext(output),".", response_format)
  writeBin(content(response, as="raw"), output)

  return(output)
}
