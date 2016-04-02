module Renderer where

import List exposing (map)
import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (style)
import Layout exposing (..)

pixelize : Float -> String
pixelize v = (toString v) ++ "px"

styleFromBounds : Bounds -> Attribute
styleFromBounds (Bounds x y w h) =
    style [
        ("position", "absolute"),
        ("left", pixelize x),
        ("top", pixelize y),
        ("width", pixelize w),
        ("height", pixelize h)
    ]
    
composite : Bounds -> List Html -> Html
composite absolute children =
    div [styleFromBounds absolute] children

render : ResolvedLayout -> Html
render layout =
    case layout of
        ResolvedLeaf html (_, absolute) ->
            composite absolute [html]
        ResolvedComposite layoutType (_, absolute) children ->
            composite absolute <| map render children
