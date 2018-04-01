external parseResponse : string -> 'a = "parse" [@@bs.scope "JSON"][@@bs.val]

let query currency direction = 
  Request_promise_native.request 
    ("https://api.coinbase.com/v2/prices/" ^ currency ^ "-USD/" ^ direction)
  |> Js.Promise.then_ (fun htmlString -> 
      Js.Promise.resolve (currency,parseResponse htmlString))

let get_prices () = 
  let curs = [|"btc";"eth";"ltc";"bch"|] in 

  let bids = 
    Js.Array.map (fun cur -> query cur "sell") curs
    |> Js.Promise.all
  in
  let asks = 
    Js.Array.map (fun cur -> query cur "buy") curs
    |> Js.Promise.all
  in 

  Js.Promise.all2 (bids,asks)
  |> Js.Promise.then_ (fun (bids,asks) -> 
      bids
      |> Js.Array.map (fun (cur,bid) -> 
          let ask_opt = Js.Array.find (fun (cur1,_) -> cur1=cur) asks in 
          match ask_opt with 
          | None -> None 
          | Some (_,ask) -> 
              Some Types.{
                for_=cur;
                dom="usd";
                bid=bid##data##amount;
                ask=ask##data##amount;
              }
      )
          |> Js.Promise.resolve
  )




