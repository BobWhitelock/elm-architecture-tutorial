import Html exposing (Html, div, button)
import Html.App as Html
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model = {
  time : Time,
  running : Bool
}


init : (Model, Cmd Msg)
init =
  (Model 0 True, Cmd.none)



-- UPDATE


type Msg
  = Tick Time
  | ToggleRunning


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ({model | time = newTime}, Cmd.none)
    ToggleRunning ->
      ({model | running = (not model.running)}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.running of
    True ->
      Time.every second Tick
    False ->
      Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  let
    buttonText =
      if model.running then "Stop" else "Start"
  in
    div []
    [ svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , clockHand model.time Time.inSeconds 40
      , clockHand model.time Time.inMinutes 30
      , clockHand model.time Time.inHours 20
      ]
      , button [onClick ToggleRunning] [text buttonText]
    ]

clockHand : Time -> (Time -> Float) -> Float -> Html Msg
clockHand time inUnits length =
  let
    angle =
      turns (inUnits time)

    handX =
      toString (50 + length * cos angle)

    handY =
      toString (50 + length * sin angle)
  in
      line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
