open Jest
open Expect

let () = 
  testPromise "arb()" (fun () -> 
    Webhook.arb () 
    |> Js.Promise.then_ (fun str -> 
        Js.log str;
        let expected = 
          match 
            ((Js.String.split "No arbitrage" str 
            |> Js.Array.length) - 1)
          with 
          | 0 -> 10 
          | 1 -> 7
          | 2 -> 4
          | _ -> 0
          
        in
        str 
        |> Js.String.split "\n"
        |> Js.Array.length
        |> expect |> toBe expected
        |> Js.Promise.resolve)
  )
