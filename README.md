# RskAI: Ask AI Models Questions with R

Author: Weiyang Tao ([weiyangtao1513\@gmail.com](mailto:weiyangtao1513@gmail.com){.email})
Date: 2024-03-23

------------------------------------------------------------------------

This package uses the APIs provided by Google's [`Gemini`](https://ai.google.dev/) and OpenAI's [`ChatGPT`](https://platform.openai.com/docs/overview) to allow you to:

-   ask `Gemini` questions and get answers for free,

-   ask `ChatGPT` questions and get answers (not free, charged by ChatGPT),

-   ask `ChatGPT` to convert text to audios (not free, charged by ChatGPT),

-   ask `ChatGPT` to generate transcriptions/subtitles for audios (not free, charged by ChatGPT),

-   ask `ChatGPT` to generate images with texts (not free, charged by ChatGPT).

More functionalities will be implemented in the future.

**Of note, these APIs are accessible in only part of the world. Check [here](https://ai.google.dev/available_regions) to see if you are able to use the `Gemini` API, and [here](https://platform.openai.com/docs/supported-countries) for `ChatGPT`. The option to use proxy is yet to be implemented.**

------------------------------------------------------------------------

# Installation

``` r
if(suppressWarnings(!require("devtools"))){
  install.package("devtools")
}

if(suppressWarnings(!require("RskAI"))){
  devtools::install_github("paodan/RskAI")
}
```

------------------------------------------------------------------------

# Configure API keys on your computer

## Configure API key for `Gemini`

You need to create your own API key to use `Gemini` API. Here are the steps to create your key:

(1) go to this <https://ai.google.dev/> address and click `Get API key in Google AI Studio`;

(2) Then select `Get API key`;

(3) Consent the agreement;

(4) Click Create API key;

(5) Copy this API key and define it into `~/.Renviron` file in bash terminal by `echo 'GEMINIKEY=YOUR_API_KEY' >> ~/.Renviron`, and remember replace `YOUR_API_KEY` by your real API key that you just created.

Currently, `Gemini` API is free to use and is allowed in 60+ countries, which do not include mainland China, Germany, etc.

## Configure API key for `ChatGPT`

To use `ChatGPT` API, you also need to create your own API key. Here are the general steps to create a `ChatGPT` API key:

(1) Sign up for OpenAI: Visit the OpenAI website and sign up for an account if you haven't already. Go to OpenAI website.

(2) Access API documentation: Once logged in, navigate to the API documentation section to learn more about the available endpoints, pricing, and usage limits.

(3) Generate API key: After familiarizing yourself with the API, you can generate an API key from your account dashboard. This key is required to authenticate your requests to the `ChatGPT` API.

(4) Copy this API key and define it into `~/.Renviron` file in bash terminal by `echo 'OPENAI_API_KEY=YOUR_API_KEY' >> ~/.Renviron`, and remember replace `YOUR_API_KEY` by your real API key that you just created.

**PS: ChatGPT API is not free, remember to top-up \$5 (minimum) to let your key authorized. After top-up if you are still getting errors, then redo the above steps.**

------------------------------------------------------------------------

# Examples

## Example 1: Ask Gemini questions

``` r
# Ask Gemini an English question
askGemini("Who are you")

# Ask Gemini a Chinese question
askGemini("你是谁")

# Ask Gemini a Franch question
askGemini("Qui es-tu")

# Ask Gemini a Spanish question
askGemini("Quién eres")
```

You would get some texts that resemble the following:

```         
> # Ask Gemini an English question
> askGemini("Who are you")
I am Gemini, a multi-modal AI model, developed by Google.> 
> # Ask Gemini a Chinese question
> askGemini("你是谁")
我是 Gemini，是 Google 开发的多模态 AI 语言模型。> 
> # Ask Gemini a Franch question
> askGemini("Qui es-tu")
Je suis Gemini, un grand modèle multimodal, entraîné par Google.> 
> # Ask Gemini a Spanish question
> askGemini("Quién eres")
Soy Gemini, un gran modelo multimodal, entrenado por Google. Estoy diseñado para comprender y generar lenguaje humano, responder preguntas y brindar información sobre una amplia gama de temas. Piense en mí como un asistente digital súper inteligente que puede ayudarlo con sus tareas y consultas basadas en texto.
```

## Example 2: Ask ChatGPT questions

``` r
askChatGPT(text = "Compose a poem that explains the concept of recursion in programming.")
```

You would get some texts that resemble the following:

```         
In the world of code, where logic reigns,
There’s a concept that often entertains,
Recursion, a method both simple and profound,
Let me explain with a poetic sound.

Imagine a function that calls itself,
A loop of reflection, a digital elf,
It peeks through the looking glass of time,
Repeating its dance, a beautiful chime.

Like a Russian nesting doll, it goes deeper and deeper,
Into its own essence, a recursive sleeper,
Breaking down problems, into pieces so small,
Until the solution emerges, standing tall.

A function that looks within its own soul,
Unraveling mysteries, achieving its goal,
With elegance and grace, it travels the land,
Recursion, a beauty, so truly grand.

So remember this lesson, my dear coder friend,
In the realm of programming, there’s no dead end,
With recursion as your ally, you’ll conquer the maze,
And unlock the secrets, in this digital craze.
```

## Example 3: Ask ChatGPT to convert texts to an audio file

``` r
# Convert texts to an audio file automatically accroding to it's language
# English
text2Speach("Convert this into an English monologue.", output = "English.mp3")

# Chinese
text2Speach("把这个转换成中文普通话.", voice = "nova", output = "Chinese.mp3")

# Spanish
text2Speach("Convierte esto al habla española.", output = "Spanish.mp3")

# Franch
text2Speach("Convertissez ceci en un monologue anglais", output = "Franch.mp3")

# Mixture of English and Chinese
# And try another voice "nova"
text2Speach("把这个English conversation转换成中文对话.", voice = "nova", output = "Mix.mp3")
```

By running above scripts, you would get mp3 audio files in your current working directory.

## Example 4: Ask ChatGPT to transcribe an audio file

``` r
# Convert texts to text
x = audioTranscription("Mix.mp3", response_format = "text")
print(x)

# Convert audio to subtitiles
x = audioTranscription("Mix.mp3", response_format = "srt")
print(x)
```

## Example 5: Ask ChatGPT to generate images using texts

Please note: running `text2Image` function is relatively more expensive than running other text- or audio- related functions.

By running the following scripts, you will download two images (size = 1024\*1024) of an otter. One is of `vivid` type, which is like a cartoon, another is of `natural` type, which is like a real animal.

``` r
prompt = "A cute baby sea otter"

# use the default DALL-E3 model to generate a image of 'vivid' type
text2Image(prompt, output = "otter.png")

# use the default DALL-E2 model to generate a image of 'natural' type
text2Image(prompt, model = "dall-e-2", output = "otter2.png")
```

## To be continued ...
