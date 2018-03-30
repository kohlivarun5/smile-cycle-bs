let credentials = Coinbase.credentials 
                      ~apiKey:""
                      ~apiSecret:""
let client = Coinbase.client credentials 

let app = Express.app () ;;

Express.get app "/" (fun req resp -> 
  Js.log req;
  Coinbase.ExchangeRates.get 
    client 
    (Coinbase.ExchangeRates.req ~currency:"BTC")
    (fun _ rates -> 

      let entries = Js.Dict.entries rates##data##rates in 
      Js.log(entries);
      let res = 
        Array.fold_left 
          (fun res (key,value) -> 
              res ^ Printf.sprintf "\n %s : %s" key value )
          "" entries 
      in
      Express.send resp res; ());
  resp
  );;

Express.listen app 3000;;
