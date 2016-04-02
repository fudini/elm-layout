module Layout where

{-| Flex layout resolver and renderer.
-}

import Html exposing (Html)
import Dict exposing (Dict)
import List exposing (foldl, map, map2, concatMap, append, filter, head)

type Bounds = Bounds Float Float Float Float

-- tuple ( relative, absolute )
type alias Resolver = Bounds -> List Layout -> List (Bounds, Bounds)

type Segment
    = Flex Float
    | Size Float

type LayoutType
    = Horizontal
    | Vertical

type Layout
    = Leaf Segment Html
    | Composite LayoutType Segment (List Layout)

type ResolvedLayout
    = ResolvedLeaf Html (Bounds, Bounds)
    | ResolvedComposite LayoutType (Bounds, Bounds) (List ResolvedLayout)

sumSegment : Segment -> (Float, Float) ->  (Float, Float)
sumSegment segment (sizes, flexes) =
    case segment of
        Size v -> (sizes + v, flexes)
        Flex v -> (sizes, flexes + v)

calculateTotals : List Segment -> (Float, Float)
calculateTotals = foldl sumSegment (0, 0)

flex : Float -> List Segment -> List Float
flex size segments =

    let
        (sizesTotal, flexesTotal) = calculateTotals segments
        remaining = max (size - sizesTotal) 0

    in
        map (\segment ->
                case segment of
                    Size v -> v
                    Flex v -> remaining / flexesTotal * v
            ) segments

extractSegment : Layout -> List Segment
extractSegment layout =
    case layout of
        Leaf segment _ -> [segment]
        Composite _ segment _ -> [segment]

horizontalResolver : Resolver
horizontalResolver (Bounds x y w h) children =

    let segments = concatMap extractSegment children
        resolved = flex (w - x) segments
        (_, result) =
            foldl (\size (cs, r) -> (cs + size, append r [(Bounds cs 0 size h, Bounds (cs + x) y size h)]))
                  (0, []) resolved
    in result

verticalResolver : Resolver
verticalResolver (Bounds x y w h) children =

    let segments = concatMap extractSegment children
        resolved = flex (h - y) segments
        (_, result) =
            foldl (\size (cs, r) -> (cs + size, append r [(Bounds 0 cs w size, Bounds x (cs + y) w size)]))
                  (0, []) resolved
    in result

resolveLayout : Layout-> Bounds -> ResolvedLayout
resolveLayout layout bounds =

    case layout of

        Leaf _ html -> ResolvedLeaf html (bounds, bounds)

        Composite layoutType _ children ->
            let 
                resolver =
                    case layoutType of
                        Horizontal -> horizontalResolver
                        Vertical -> verticalResolver

                resolved = resolver bounds children
                resolvedChildren = map2 (\(bounds, _) child -> resolveLayout child bounds) resolved children
            in
                ResolvedComposite layoutType (bounds, bounds) resolvedChildren
       
