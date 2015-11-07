import Html as H
import Html.Attributes as Attr
import Html.Events as HE
import Signal
import Time
import Date
import Graphics.Element
import StartApp.Simple as StartApp

type Action = Increment | Decrement

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

startTime =
    Signal.constant ()
    |> Time.timestamp
    |> Signal.map fst

model = 0.0

view address model =
    model
    |> Date.fromTime
    |> dateControl address

update action model =
    case action of
    Increment -> model + Time.minute
    Decrement -> model - Time.minute

main = StartApp.start { model = model, view = view, update = update }
