import Html as H
import Html.Attributes as Attr
import Html.Events as HE
import Signal
import Time
import Date
import Graphics.Element
import StartApp
import Effects exposing (Effects)
import Task

type alias Model = Float

type Action = Increment | Decrement | SetTime Time.Time

dateControl address date =
    let spanToString num = H.span [] [H.text (num |> toString)]
        span string = H.span [] [H.text string]
    in
    H.div [] [
        H.div [Attr.style [("font-size", "3em")]]
            [
                date |> Date.dayOfWeek |> spanToString,
                span " ",
                date |> Date.day |> spanToString,
                span " ",
                date |> Date.month |> spanToString,
                span " ",
                date |> Date.year |> spanToString,
                span " - ",
                date |> Date.hour |> spanToString,
                span ":",
                date |> Date.minute |> spanToString
            ],
        H.button [HE.onClick address Decrement] [H.text "-"],
        H.button [HE.onClick address Increment] [H.text "+"]
    ]

init = (0.0, Effects.tick SetTime)

view address model =
    model
    |> Date.fromTime
    |> dateControl address

update action model =
    let newModel =
        case action of
        Increment -> model + Time.minute
        Decrement -> model - Time.minute
        SetTime t -> t
    in
        (newModel, Effects.none)

app = StartApp.start { init = init, update = update, view = view, inputs = [] }

main = app.html
