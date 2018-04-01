open Jest
open Expect

let () = 
  testPromise "arb()" (fun () -> 
    Webhook.arb () 
    |> Js.Promise.then_ (fun str -> 
        Js.log str;
        str 
        |> Js.String.split "\n"
        |> Js.Array.length
        |> expect 
        |> toBe 10
        |> Js.Promise.resolve)
  )
