import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random
import List



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  {
    dice: List Die
  }

type alias Die =
  {
    face : Int
  }

init : (Model, Cmd Msg)
init =
  ({dice = [Die 1, Die 2]}, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace (List Int)
  | AddDie
  | RemoveDie


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, generateNewFaces model.dice)

    NewFace newFaces ->
      (Model (updateDice newFaces model.dice), Cmd.none)

    AddDie ->
      ({model | dice = Die 1 :: model.dice }, Cmd.none)

    RemoveDie ->
      ({model | dice = List.drop 1 model.dice}, Cmd.none)

generateNewFaces : List Die -> Cmd Msg
generateNewFaces dice =
  Random.generate NewFace (Random.list (List.length dice) (Random.int 1 6))

updateDice : List Int -> List Die -> List Die
updateDice newFaces dice =
  List.map2 updateDie newFaces dice

updateDie : Int -> Die -> Die
updateDie newFace die =
  Die newFace


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map showFace model.dice)
    , button [ onClick Roll ] [ text "Roll" ]
    , button [ onClick AddDie ] [ text "Add Die" ]
    , button [ onClick RemoveDie ] [ text "Remove Die" ]
    ]

showFace : Die -> Html Msg
showFace die =
  case die.face of
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
      h1 [] [ text (toString die.face) ]
