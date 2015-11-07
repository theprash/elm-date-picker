import Html as H
import Html.Attributes as Attr
import Signal
import Time
import Date
import Graphics.Element

dateControl date =
    let spanToString num = H.span [] [H.text (num |> toString)]
        span string = H.span [] [H.text string]
    in
    H.div
        [Attr.style [("font-size", "3em")]]
        [
            date |> Date.dayOfWeek |> spanToString,
            span " ",
            date |> Date.day |> spanToString,
            span " ",
            date |> Date.month |> spanToString,
            span " - ",
            date |> Date.hour |> spanToString,
            span ":",
            date |> Date.minute |> spanToString
        ]

startTime =
    Signal.constant ()
    |> Time.timestamp
    |> Signal.map fst

main =
    startTime
    |> Signal.map Date.fromTime
    |> Signal.map dateControl
