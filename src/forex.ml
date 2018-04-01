let headers = Js.Dict.fromList ["User-Agent","Request-Promise"]

let query base cross = 
  Request_promise_native.request_opts 
    (Request_promise_native.options 
      ~json:true ~headers
      ~uri:(
        Printf.sprintf 
          "https://api.fixer.io/latest?symbols=%s&base=%s" cross base))

let get_prices base cross : float Js.Promise.t = 
  query base cross 
  |> Js.Promise.then_ (fun exch_rates -> 
      Js.Dict.get exch_rates##rates cross 
      |> Js.Option.getExn 
      |> (fun x -> Js.log x; x)
      |> Js.Promise.resolve)
