.checkKey = function(key, type = c("GEMINIKEY", "OPENAI_API_KEY"), length){
  type = match.arg(type)
  if(is.null(key)){
    key = Sys.getenv(type)

  }
  if(nchar(key) != length){
    stop("You key is neither defined here nor as an environment variable (`", type,"`) in ~/.Renviron file.
           Please see help page of this function for the instruction.")
  }
  return(key)
}


.checkSpeed = function(speed){
  if(is.null(speed)) {
    speed = 1
  } else if(!is.finite(speed)){
    speed = 1
  } else if (speed < 0.25){
    speed = 0.25
    warning("Speed < 0.25, force it to 0.25.")
  } else if (speed > 4){
    speed = 4
    warning("Speed > 4, force it to 4.")
  }
  return(speed)
}

.checkLanguage = function(code){
  if(!is.null(code)){
    # List of ISO-639-1 language codes
    iso_639_1 = c("aa", "ab", "ae", "af", "ak", "am", "an", "ar", "as", "av", "ay", "az",
                  "ba", "be", "bg", "bi", "bm", "bn", "bo", "br", "bs",
                  "ca", "ce", "ch", "co", "cr", "cs", "cu", "cv", "cy",
                  "da", "de", "dv", "dz",
                  "ee", "el", "en", "eo", "es", "et", "eu",
                  "fa", "ff", "fi", "fj", "fo", "fr", "fy",
                  "ga", "gd", "gl", "gn", "gu", "gv",
                  "ha", "he", "hi", "ho", "hr", "ht", "hu", "hy", "hz",
                  "ia", "id", "ie", "ig", "ii", "ik", "io", "is", "it", "iu",
                  "ja", "jv",
                  "ka", "kg", "ki", "kj", "kk", "kl", "km", "kn", "ko", "kr", "ks", "ku", "kv", "kw", "ky",
                  "la", "lb", "lg", "li", "ln", "lo", "lt", "lu", "lv",
                  "mg", "mh", "mi", "mk", "ml", "mn", "mo", "mr", "ms", "mt", "my",
                  "na", "nb", "nd", "ne", "ng", "nl", "nn", "no", "nr", "nv", "ny",
                  "oc", "oj", "om", "or", "os",
                  "pa", "pi", "pl", "ps", "pt",
                  "qu",
                  "rm", "rn", "ro", "ru", "rw",
                  "sa", "sc", "sd", "se", "sg", "sh", "si", "sk", "sl", "sm", "sn", "so", "sq", "sr", "ss", "st", "su", "sv", "sw",
                  "ta", "te", "tg", "th", "ti", "tk", "tl", "tn", "to", "tr", "ts", "tt", "tw", "ty",
                  "ug", "uk", "ur", "uz",
                  "ve", "vi", "vo",
                  "wa", "wo",
                  "xh",
                  "yo", "yi",
                  "zu", "zh", "za")

    # Convert input code to lowercase for case-insensitive comparison
    code <- tolower(code)

    # Check if input code is in ISO-639-1 format
    if (any(!code %in% iso_639_1)) {
      code = NULL
      warning("Language code is not used, because it's not one of ISO 639 language codes: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes")
    }
  }
  return(code)
}


# remove NULL elements
#' @import jsonlite
input2Json = function(x){
  x = Filter(Negate(is.null), x)
  toJSON(x, auto_unbox = T, pretty = F)
}

#' @import httr
#'
input2Headers = function(x){
  add_headers(x)
}

# Wrapper function for httr::POST
httr_POST = function(
    url = NULL,
    config = list(),
    ...,
    body = NULL,
    encode = c("multipart", "form", "json", "raw"),
    handle = NULL,
    verbose = FALSE){

  if(verbose){
    response = httr::POST(
      url = url,
      config = config,
      ...,
      body = body,
      encode = encode,
      handle = handle,
      verbose()
    )
  } else {
    response = httr::POST(
      url = url,
      config = config,
      ...,
      body = body,
      encode = encode,
      handle = handle
    )
  }
  return(response)
}





