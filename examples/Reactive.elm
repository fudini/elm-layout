import Graphics.Element exposing (show)
import Window exposing (dimensions)

import Layout exposing (..)
import Renderer exposing (render)
import Components exposing (..)

layout = Composite Vertical (Flex 1) [
        Leaf (Size 50) header,
        Composite Horizontal (Flex 1) [
            Leaf (Size 100) leftNav,
            Leaf (Flex 2) leftContent,
            Composite Vertical (Flex 1) [
                Leaf (Size 40) rightContentHeader,
                Leaf (Flex 1) rightContent
            ],
            Leaf (Size 100) rightNav
        ],
        Leaf (Size 50) footer
    ]

toBounds : (Int, Int) -> Bounds
toBounds (w, h) = Bounds 0 0 (toFloat w) (toFloat h)

view = toBounds >> resolveLayout layout >> render

main = Signal.map view dimensions
