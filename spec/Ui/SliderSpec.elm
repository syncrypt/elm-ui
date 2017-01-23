import Spec exposing (..)

import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Html exposing (div, text)

import Ui.Container
import Ui.Slider

import Ui.Styles.Theme exposing (default)
import Ui.Styles.Container
import Ui.Styles.Slider
import Ui.Styles

import Steps exposing (keyDown)
import Json.Encode as Json

view : Ui.Slider.Model -> Html.Html Ui.Slider.Msg
view model =
  div
    [ ]
    [ Ui.Styles.embedSome
      [ Ui.Styles.Slider.style
      , Ui.Styles.Container.style
      ] default
    , Ui.Container.row []
      [ Ui.Slider.view model
      , Ui.Slider.view { model | disabled = True }
      , Ui.Slider.view { model | readonly = True }
      ]
    ]

assertPercent value =
  assert.styleEquals
    { selector = "ui-slider-progress"
    , style = "width"
    , value = (toString value) ++ "%"
    }

mouseMove top left =
  steps.dispatchEvent "mousemove"
  (Json.object
    [ ( "pageX", Json.int left )
    , ( "pageY", Json.int top )
    ]
  )
  "document"

mouseDown left top selector =
  steps.dispatchEvent "mousedown"
  (Json.object
    [ ( "pageX", Json.int left )
    , ( "pageY", Json.int top )
    ]
  )
  "ui-slider"

specs : Node
specs =
  describe "Ui.Slider"
    [ layout
      [ ("ui-slider"
        , { top = 0
          , left = 0
          , bottom = 0
          , right = 0
          , width = 200
          , height = 50
          , zIndex = 1
          }
        )
      ]
    , it "has tabindex"
      [ assert.elementPresent "ui-slider[tabindex]"
      ]

    , context "Dragging outside the mouse while dragging"
      [ it "sets the value to the min or max"
        [ mouseDown 50 25 "ui-slider"
        , assertPercent 25
        , mouseMove 600 600
        , assertPercent 100
        , mouseMove 0 0
        , assertPercent 0
        ]
      ]

    , context "Pressing a mouse button down in the middle"
      [ it "sets the value up to that position"
        [ mouseDown 33 25 "ui-slider"
        , assertPercent 16.5
        , assert.styleEquals
          { selector = "ui-slider-handle"
          , style = "left"
          , value = "16.5%"
          }
        ]
      ]

    , context "Release the mouse"
      [ it "stops dragging"
        [ mouseDown 33 25 "ui-slider"
        , assertPercent 16.5
        , mouseMove 300 300
        , assertPercent 100
        , steps.dispatchEvent
          "mouseup"
          (Json.object
            [ ( "pageX", Json.int 0 )
            , ( "pageY", Json.int 0 )
            ])
          "document"
        , mouseMove 0 0
        , assertPercent 100
        ]
      ]

    , context "Pressing keys"
      [ before
        [ keyDown 39 "ui-slider"
        , assertPercent 1
        , keyDown 39 "ui-slider"
        , assertPercent 2
        ]
      , context "Up arrow"
        [ it "decrements the value by 1 percent"
          [ keyDown 38 "ui-slider"
          , assertPercent 3
          ]
        ]
      , context "Right arrow"
        [ it "decrements the value by 1 percent"
          [ keyDown 39 "ui-slider"
          , assertPercent 3
          ]
        ]
      , context "Down arrow"
        [ it "decrements the value by 1 percent"
          [ keyDown 40 "ui-slider"
          , assertPercent 1
          ]
        ]
      , context "Left arrow"
        [ it "decrements the value by 1 percent"
          [ keyDown 37 "ui-slider"
          , assertPercent 1
          ]
        ]
      ]
    ]

main =
  runWithProgram
    { subscriptions = Ui.Slider.subscriptions
    , update = Ui.Slider.update
    , init = Ui.Slider.init
    , view = view
    } specs
