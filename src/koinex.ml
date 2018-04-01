let headers = Js.Dict.fromList ["User-Agent","Request-Promise"]

let query () = 
  Request_promise_native.request_opts 
    (Request_promise_native.options 
      ~uri:"https://koinex.in/api/ticker"
      ~json:(Js.Boolean.to_js_boolean true) ~headers)

let get_prices () : Types.quotes_p = 
  query () 
  |> Js.Promise.then_ (fun data -> 
    data##stats 
    |> Js.Dict.entries
    |> Js.Array.map (fun (prod,market) ->  
        let highest_bid,lowest_ask = market##highest_bid,market##lowest_ask in 
        {
          Types.for_=Js.String.toLowerCase prod;
          dom="inr";
          bid=highest_bid;
          ask=lowest_ask;
        }
    )
    |> Js.Promise.resolve 
  )

