let credentials = Coinbase.credentials 
                      ~apiKey:""
                      ~apiSecret:""
let client = Coinbase.client credentials 

let app = Express.app () ;;

Express.use_json app (BodyParser.json ());;
Express.use_urlencoded app (BodyParser.urlencoded (BodyParser.urlencoded_params ~extended:true));;

Express.get app "/" (fun req resp -> 
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

Express.get app "/webhook" (fun req resp -> 
  Js.log req;
  Express.send resp "Webhook");;


Express.listen app 3000;;
