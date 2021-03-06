import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task



main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , gifUrl : String
  , message : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )



-- UPDATE


type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
  | UpdateTopic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({model | message = "Loading..."}, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl "", Cmd.none)

    FetchFail _ ->
      ({model | message = "We failed to get another gif..."}, Cmd.none)

    UpdateTopic topic ->
      ({model | topic = topic}, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , select [onInput UpdateTopic]
    [ (option [value "cats"] [text "Cats"])
    , (option [value "dogs"] [text "Dogs"])
    , (option [value "things"] [text "Things"])
    ]
    , br [] []
    , img [src model.gifUrl] []
    , span [] [text model.message]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "//api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
