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
          | 0 -> 6
          | 1 -> 5 
          | 2 -> 4 
          | _ -> 100 
          
        in
        str 
        |> Js.String.split "\n"
        |> Js.Array.length
        |> expect |> toBeGreaterThanOrEqual expected
        |> Js.Promise.resolve)
  )

let () = 
  testPromise "coinbase_balance()" (fun () -> 
    Webhook.coinbase_balance () 
    |> Js.Promise.then_ (fun str -> 
        Js.log str;
        str 
        |> Js.String.split "\n"
        |> Js.Array.length
        |> expect |> toBeGreaterThanOrEqual 4
        |> Js.Promise.resolve)
  )
