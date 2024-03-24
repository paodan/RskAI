#' Convert audio to texts or subtitles.
#' @param file audio file object (not file name) to transcribe, in one of these
#' formats: `flac`, `mp3`, `mp4`, `mpeg`, `mpga`, `m4a`, `ogg`, `wav`, or `webm.`
#' @param model the model name.
#' @param language The language of the input audio. Supplying the input language
#' in ISO-639-1 format will improve accuracy and latency. Defaults NULL.
#' @param prompt optional prompt parameter to pass a dictionary of the correct spellings.
#' Only the first 244 tokens of the prompt are considered. Defaults NULL.
#' @param response_format Defaults to `json`.
#' The format of the transcript output, in one of these options: `json`, `text`,
#' `srt`, `verbose_json`, `vtt.`
#' @param temperature numeric, between 0 and 1. Defaults to 0.
#' The sampling temperature, between 0 and 1. Higher values like 0.8 will make the
#' output more random, while lower values like 0.2 will make it more focused and
#' deterministic. If set to 0, the model will use log probability to automatically
#' increase the temperature until certain thresholds are hit.
#' @param timestamp_granularities either "segment" (default) or "word".
#' The timestamp granularities to populate for this transcription. `response_format`
#' must be set `verbose_json` to use timestamp granularities. Either or both of
#' these options are supported: `word`, or `segment.` Note: There is no additional
#' latency for segment timestamps, but generating word timestamps incurs additional latency.
#' @examples
#' \dontrun{
#' # Convert texts to audio
#' text2Speach("把这个English conversation转换成中文对话.", voice = "nova",
#'              output = "Mix.mp3")
#'
#' # Convert audio to verbose_json
#' x = audioTranscription("Mix.mp3", response_format = "verbose_json",
#' timestamp_granularities = "word", returnFull = T)
#' class(x)
#' content(x)
#'
#' # Convert audio to text
#' x = audioTranscription("Mix.mp3", response_format = "text")
#'
#' # Convert audio to subtitiles
#' x = audioTranscription("Mix.mp3", response_format = "srt")
#'
#' }
#' @export
audioTranscription = function(file,
                              model = c("whisper-1"),
                              language = NULL,
                              prompt = NULL,
                              response_format = c("json", "srt", "text", "verbose_json", "vtt"),
                              temperature = NULL,
                              timestamp_granularities = c("segment", "word"),
                              key = NULL, returnFull = FALSE, verbose = FALSE){
  if(missing(file)) stop("file must be provided.")
  if(file.exists(file)) {
    file = (upload_file(file))
  } else {
    stop("file does not exist!")
  }
  model = match.arg(model)
  language = .checkLanguage(language)
  response_format = match.arg(response_format)
  timestamp_granularities = match.arg(timestamp_granularities)
  if(response_format != "verbose_json"){
    timestamp_granularities = NULL
    # message("response_format is not verbose_json, so timestamp_granularities is not used.")
  }
  key = .checkKey(key, "OPENAI_API_KEY", 51)
  url = 'https://api.openai.com/v1/audio/transcriptions'

  # Input (-F flag) data
  data = list(file = file, model = model, response_format = response_format, prompt = prompt, language = language)
  # data = input2Json(data)

  # Set request headers (-H flag)
  headers = c('Content-Type' = 'multipart/form-data',
              'Authorization' = paste('Bearer', key))
  headers = input2Headers(headers)

  # Send POST request
  response = httr_POST(url = url, config = headers, body = data,
                       encode = "multipart", verbose = verbose)

  if(!returnFull){
    res = switch(response_format,
                 json = content(response)$text,
                 srt = content(response),
                 text = content(response),
                 verbose_json = content(response)$segments[[1]]$text,
                 vtt = content(response))
    class(res) = "AI_response"
    return(res)
  } else {
    return(response)
  }
}
