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

startTime =
    Signal.constant ()
    |> Time.timestamp
    |> Signal.map fst
    |> Signal.map SetTime

type Action = Increment | Decrement | SetTime Time.Time | SetNow

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
        H.button [HE.onClick address SetNow] [H.text "now"],
        H.button [HE.onClick address Decrement] [H.text "-"],
        H.button [HE.onClick address Increment] [H.text "+"]
    ]

init = (0.0, Effects.tick SetTime)

view address model =
    model
    |> Date.fromTime
    |> dateControl address

update action model =
    case action of
    Increment -> (model + Time.minute, Effects.none)
    Decrement -> (model - Time.minute, Effects.none)
    SetTime t -> (t, Effects.none)
    SetNow -> (model, Effects.tick SetTime)

app = StartApp.start { init = init, update = update, view = view, inputs = [startTime] }

main = app.html

port tasks : Signal (Task.Task Effects.Never ())
port tasks = app.tasks
