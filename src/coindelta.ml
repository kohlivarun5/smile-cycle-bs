external parseResponse : string -> 'a = "parse" [@@bs.scope "JSON"][@@bs.val]
let query () = 
  Request_promise_native.request "https://coindelta.com/api/v1/public/getticker" 
  |> Js.Promise.then_ (fun htmlString -> 
      parseResponse htmlString |> Js.Promise.resolve)
external parseResponse : string -> 'a = "parse" [@@bs.scope "JSON"][@@bs.val]


let get_prices () : Types.quotes_p = 
  query () 
   |> Js.Promise.then_ (fun data -> 
      data |> 
      Js.Array.map (fun data -> 
        let market = data##_MarketName in 
        let [|for_;dom|] = Js.String.split "-" market in 
        let bid = data##_Bid in 
        let ask = data##_Ask in 
        { Types.for_;dom;bid;ask })
      |> (fun x -> Js.log x; x)
      |> Js.Promise.resolve)
