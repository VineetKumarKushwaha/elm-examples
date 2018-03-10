module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

--Model
type TodoState = COMPLETED | PENDING | ARCHIVED

type Filter = ALL | TodoState

type alias Todo = {
    heading: String,
    desc: String,
    state: TodoState
}

type alias Model = {
    todos: List Todo,
    filterApplied: Filter,
    inputVal: String
}


init : (Model, Cmd Msg)
init =
   ( {
      todos = []
    , filterApplied = ALL
    , inputVal = ""
   }, Cmd.none )


   -- MESSAGES


type Msg
    = NoOp
    | KeyPressed Int
    | InputChanged String

-- VIEW

-- onChange : (String -> msg) -> Html.Attribute msg
-- onChange tagger =
--   on "change" (Json.map tagger Html.Events.targetValue)


onKeyPress : (Int -> msg) -> Html.Attribute msg
onKeyPress tagger =
  on "keypress" (Json.map tagger Html.Events.keyCode)


view : Model -> Html Msg
view model =
    Html.div [ classList [ ("todo-container", True) ] ]
        [
            Html.input [
              onKeyPress KeyPressed
            , onInput InputChanged
            , type_ "text"
            , placeholder "Please type......."
            , value model.inputVal
            ] [],
            Html.ul [] (List.map (\todo -> Html.li [] [text todo.heading]) model.todos)
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        InputChanged val ->
            ( { model | inputVal = val }, Cmd.none )

        KeyPressed keyCode ->
             if keyCode == 13 &&  model.inputVal /= "" then
              ( {
                  model |
                    inputVal = "",
                    todos =  ({
                        heading = model.inputVal,
                        desc = "",
                        state = PENDING
                        })  :: model.todos
                  }, Cmd.none )
            else
              ( model, Cmd.none )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
