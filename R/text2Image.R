#' Use DALL-E2 or DALL-E3 model to convert text to a image (or images).
#' @param prompt character, A text description of the desired image(s).
#' The maximum length is 1000 characters for `dall-e-2` and 4000 characters for
#' `dall-e-3` model.
#' @param model The model to use for image generation. Defaults to `dall-e-3`.
#' @param n The number of images to generate. Must be between 1 and 10.
#' For `dall-e-3`, only `n=1` is supported. Defaults to 1.
#' @param quality The quality of the image that will be generated.
#' `hd` creates images with finer details and greater consistency across the image.
#' This param is only supported for `dall-e-3`. Defaults to `standard`.
#' @param response_format The format in which the generated images are returned.
#' Must be one of `url` or `b64_json`. URLs are only valid for 60 minutes after the
#' image has been generated. Defaults to `url`.
#' @param size The size of the generated images. Must be one of `256x256`, `512x512`,
#' or `1024x1024` for `dall-e-2`. Must be one of `1024x1024`, `1792x1024`, or
#' `1024x1792` for `dall-e-3` models. Defaults to `1024x1024`.
#' @param style The style of the generated images. Must be one of `vivid` or `natural`.
#' Vivid causes the model to lean towards generating hyper-real and dramatic images.
#' Natural causes the model to produce more natural, less hyper-real looking images.
#' This param is only supported for `dall-e-3`. Defaults to `vivid`.
#' @param user A unique identifier representing your end-user, which can help
#' OpenAI to monitor and detect abuse.
#' @param output Either NULL (default) or character for output picture file name.
#' @param the API key for OpenAI
#' @param returnFull logical, whether to return a `response` object. Default is FALSE.
#' @param verbose logical, whether to show the respoding details of the server. Default is FALSE.
#' @export
#' @examples
#' \dontrun{
#' # Of note: running text2Image function is relatively more expensive than
#' # running other text- or audio- related functions.
#'
#' prompt = "A cute baby sea otter"
#'
#' # use the default DALL-E3 model to generate a image of 'vivid' type
#' text2Image(prompt, output = "otter.png")
#'
#' # use the default DALL-E2 model to generate a image of 'natural' type
#' text2Image(prompt, model = "dall-e-2", output = "otter2.png")
#' }
#'
text2Image = function(prompt,
                      model = c("dall-e-3", "dall-e-2"),
                      n = 1,
                      quality = c("standard", "hd"),
                      response_format = c("url", "b64_json"),
                      size = c("1024x1024", "1792x1024", "1024x1792", "256x256", "512x512"),
                      style = c("vivid", "natural"),
                      user = NULL,
                      output = NULL,
                      key = NULL, returnFull = FALSE, verbose = FALSE){
  if(missing(prompt)) stop("prompt must be provided.")
  model = match.arg(model)
  if(model == "dall-e-3"){
    n = 1
  } else {
    if(n > 10){
      n = 10
    } else if (n < 1){
      n = 1
    } else {
      n = as.integer(n)
    }
  }
  quality = match.arg(quality)
  if(model != "dall-e-3"){
    quality  = NULL
  }
  response_format = match.arg(response_format)
  size = match.arg(size)
  if(model == "dall-e-3"){
    if(!size %in% c("1024x1024", "1792x1024", "1024x1792")){
      size = "1024x1024"
    }
  } else {
    if(!size %in% c("1024x1024", "256x256", "512x512")){
      size = "1024x1024"
    }
  }
  style = match.arg(style)
  if(model != "dall-e-3") style = NULL

  key = .checkKey(key, "OPENAI_API_KEY", 51)
  url = 'https://api.openai.com/v1/images/generations'

  # Input (-F flag) data
  data = list(prompt = prompt, model = model, n = n, quality = quality,
              response_format = response_format, size = size, style = style, user = user)
  data = input2Json(data)

  # Set request headers (-H flag)
  headers = c('Content-Type' = 'application/json',
              'Authorization' = paste('Bearer', key))
  headers = input2Headers(headers)

  # Send POST request
  response = httr_POST(url = url, config = headers, body = data,
                       # encode = "multipart",
                       verbose = verbose)

  res = content(response)
  res = list(revised_prompt = res$data[[1]]$revised_prompt,
             url = res$data[[1]]$url)

  if(!is.null(output)){
    stutus = download.file(res$url, destfile = output)
    if(stutus == 0) {
      message("Picture is downloaded as: ", normalizePath(output))
    } else {
      warning("Failed to download the picture.")
    }
  }

  if(!returnFull){
    return(res)
  } else {
    return(response)
  }
}
