import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { dieFace : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    NewFace newFace ->
      (Model newFace, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ showFace model.dieFace
    , button [ onClick Roll ] [ text "Roll" ]
    ]

showFace : Int -> Html Msg
showFace dieFace =
  case dieFace of
    1 ->
      img [ src "http://etc.usf.edu/clipart/42100/42158/die_01_42158_sm.gif" ] []
    2 ->
      img [ src "http://etc.usf.edu/clipart/42100/42159/die_02_42159_sm.gif" ] []
    3 ->
      img [ src "http://etc.usf.edu/clipart/42100/42160/die_03_42160_sm.gif" ] []
    4 ->
      img [ src "http://etc.usf.edu/clipart/42100/42161/die_04_42161_sm.gif" ] []
    5 ->
      img [ src "http://etc.usf.edu/clipart/42100/42162/die_05_42162_sm.gif" ] []
    6 ->
      img [ src "http://etc.usf.edu/clipart/42100/42164/die_06_42164_sm.gif" ] []
    _ ->
      -- Should never happen.
      h1 [] [ text (toString dieFace) ]
