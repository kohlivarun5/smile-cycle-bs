open Jest
open Expect

let () = 
  testPromise "arb()" (fun () -> 
    Webhook.arb () 
    |> Js.Promise.then_ (fun str -> 
        str 
        |> Js.String.split "\n"
        |> Js.Array.length
        |> expect 
        |> toBe 5
        |> Js.Promise.resolve)
  )
