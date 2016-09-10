import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String exposing (length)

main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age : String
  }


model : Model
model =
  Model "" "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      { model | age = age }



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , input [ type' "number", placeholder "Age", onInput Age ] []
    , viewValidation model
    ]


viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.password /= model.passwordAgain then
        error  "Passwords do not match!"
      else if length model.password < 8 then
        error  "Password too short"
      else if invalidAge model.age then
        error "You can't be that old!"
      else
        ok
  in
    div [ style [("color", color)] ] [ text message ]

error : String -> (String, String)
error string =
  ("red", string)

ok : (String, String)
ok =
  ("green", "OK")

invalidAge : String -> Bool
invalidAge age =
  case String.toInt age of
    Ok int ->
      int < 0
    Err _ ->
      True
