module Range exposing (main)

import Browser
import DatePicker exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time


type alias Model =
    { calendar : DatePicker.DatePicker }


type Msg
    = DatePickerMsg DatePicker.Msg
    | PreviousMonth
    | NextMonth


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( { calendar = DatePicker.initCalendar DatePicker.Range }
    , Cmd.map DatePickerMsg DatePicker.receiveDate
    )


view : Model -> Html Msg
view model =
    div []
        [ h2 [ class "helvetica m0" ] [ text "Range DatePicker" ]
        , button [ id "previous-month", class "bn pointer gray", onClick PreviousMonth ] [ text "<" ]
        , DatePicker.showCalendar model.calendar (DatePicker.getMonth model.calendar) config
            |> Html.map DatePickerMsg
        , button [ id "next-month", class "bn pointer gray", onClick NextMonth ] [ text ">" ]
        ]


config : DatePicker.Config
config =
    let
        config_ =
            DatePicker.defaultConfig
    in
    { config_
        | rangeClass = "bg-dark-red white"
        , rangeHoverClass = "bg-dark-red moon-gray"
        , selectedClass = "bg-dark-red white selected"
        , weekdayFormat = "ddd"
        , validDate = validDate
    }


validDate : Maybe Date -> Maybe Date -> Bool
validDate date currentDate =
    let
        toInt =
            Time.posixToMillis
    in
    case ( date, currentDate ) of
        ( _, Nothing ) ->
            True

        ( Just date1, Just date2 ) ->
            Time.posixToMillis date1 > Time.posixToMillis date2

        ( Nothing, Just _ ) ->
            False


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DatePickerMsg datePickerMsg ->
            ( { model | calendar = DatePicker.update datePickerMsg model.calendar }
            , Cmd.none
            )

        PreviousMonth ->
            ( { model | calendar = DatePicker.previousMonth model.calendar }
            , Cmd.none
            )

        NextMonth ->
            ( { model | calendar = DatePicker.nextMonth model.calendar }
            , Cmd.none
            )
