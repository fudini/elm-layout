module Components where

import List exposing (append)
import Html exposing (div, text)
import Html.Attributes exposing (style)

sizeStyle = [
        ("width", "100%"),
        ("height", "100%")
    ]

getStyle color = ("background-color", color) :: sizeStyle
    |> style

header =
    div [getStyle "red"] [text "Header"]

footer =
    div [getStyle "green"] [text "Footer"]

leftNav =
    div [getStyle "blue"] [text "Left Nav"]

rightNav =
    div [getStyle "yellow"] [text "Right Nav"]

leftContent =
    div [getStyle "purple"] [text "Left Content"]

rightContent =
    div [getStyle "cyan"] [text "Right Content"]

rightContentHeader =
    div [getStyle "blue"] [text "Right Content Header"]