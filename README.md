# Flex layout resolver and renderer for Elm

## Example layout resolving and rendering:

```elm
import Html exposing (div)
import Graphics.Element exposing (show)

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

bounds = Bounds 0 0 800 600

resolved = resolveLayout layout bounds
rendered = render resolved

main = rendered
```