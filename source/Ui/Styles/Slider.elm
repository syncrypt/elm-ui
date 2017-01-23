module Ui.Styles.Slider exposing (style)

import Css.Properties exposing (..)
import Css exposing (..)

import Ui.Styles.Theme as Theme exposing (Theme)
import Ui.Styles.Mixins as Mixins

style : Theme -> Node
style theme =
  selector "ui-slider"
    [ Mixins.defaults
    , boxSizing contentBox
    , minWidth (px 100)
    , alignItems center
    , position relative
    , cursor colResize
    , userSelect none
    , height (px 36)
    , display flex

    , selector "*"
      [ pointerEvents none
      ]

    , selector "ui-slider-bar"
      [ Mixins.focusedIdle theme

      , border ((px 1) . solid . theme.colors.border)
      , background theme.colors.input.color
      , borderRadius theme.borderRadius
      , position relative
      , height (px 18)
      , display block
      , flex_ "1"
      ]

    , selector "ui-slider-progress"
      [ borderRight ((px 6) . solid . transparent)
      , backgroundColor theme.colors.primary.color
      , borderRadius theme.borderRadius
      , backgroundClip contentBox
      , boxSizing borderBox
      , position absolute
      , bottom (px 3)
      , left (px 3)
      , top (px 3)
      ]

    , selector "ui-slider-handle"
      [ boxShadow
        [ { color = "rgba(0,0,0,0.5)"
          , spread = zero
          , blur = (px 4)
          , inset = False
          , x = zero
          , y = zero
          }
        ]
      , border ((px 2) . solid . theme.colors.input.color)
      , background "rgba(102,102,102,.5)"
      , borderRadius theme.borderRadius
      , boxSizing borderBox
      , marginLeft (px -4)
      , position absolute
      , width (px 8)
      , bottom (px 3)
      , top (px 3)
      ]

    , selector "&[readonly]"
      [ Mixins.readonly
      ]

    , selector "&[disabled]"
      [ Mixins.disabled

      , selector "ui-slider-bar"
        [ Mixins.disabledColors theme
        ]

      , selector "ui-slider-progress"
        [ backgroundColor theme.colors.disabledSecondary.color ]

      , selector "ui-slider-handle"
        [ opacity 0.6 ]
      ]

    , selector "&:focus"
      [ outline none

      , selector "ui-slider-bar"
        [ Mixins.focused theme ]
      ]
    ]
