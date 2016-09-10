import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
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
  , validation : (String, String)
  }


model : Model
model =
  Model "" "" "" "" initialValidation

initialValidation : (String, String)
initialValidation =
  ("orange", "Unvalidated")


-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name, validation = initialValidation }

    Password password ->
      { model | password = password, validation = initialValidation }

    PasswordAgain password ->
      { model | passwordAgain = password, validation = initialValidation }

    Age age ->
      { model | age = age, validation = initialValidation }

    Validate ->
      { model | validation = validate model }

validate : Model -> (String, String)
validate model =
  if model.password /= model.passwordAgain then
    error  "Passwords do not match!"
  else if length model.password < 8 then
    error  "Password too short"
  else if invalidAge model.age then
    error "You can't be that old!"
  else
    ok


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , input [ type' "number", placeholder "Age", onInput Age ] []
    , button [ onClick Validate ] [ text "Done" ]
    , viewValidation model
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      model.validation
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
