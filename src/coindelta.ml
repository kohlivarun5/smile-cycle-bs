let headers = Js.Dict.fromList ["User-Agent","Request-Promise"]

let query () = 
  Request_promise_native.request_opts 
    (Request_promise_native.options 
      ~json:(Js.Boolean.to_js_boolean true) ~headers
      ~uri:"https://coindelta.com/api/v1/public/getticker")

let get_prices () : Types.quotes_p = 
  query () 
   |> Js.Promise.then_ (fun data -> 
      data 
      |> Js.Array.map (fun data -> 
        let market = data##_MarketName in 
        let arb = 
          match (Js.String.split "-" market) with 
          | [|for_;dom|] -> 
            let bid = data##_Bid in 
            let ask = data##_Ask in 
            Some { Types.for_;dom;bid;ask }
          | _ -> None 
        in
        Js.Option.getExn arb)
      |> Js.Promise.resolve)
