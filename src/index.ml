let cb_client = 
  let credentials = 
    Coinbase.credentials 
      ~apiKey:Credentials.Coinbase.apiKey
      ~apiSecret:Credentials.Coinbase.apiSecret
  in
  Coinbase.client credentials 

let webhook_path = "/webhook"

let app = Express.app () ;; 

module Promise = Js.Promise;;

Express.use_json app (BodyParser.json ());;
Express.use_urlencoded app (BodyParser.urlencoded (BodyParser.urlencoded_params ~extended:true));;

Express.get app "/" (fun _ resp -> 
  Coinbase.ExchangeRates.get 
    cb_client 
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
      let _ = Express.send resp res in 
      ());
  ()
);


type url_query = < url : string >;;
Express.get app "/set_webhook" (fun (req:(url_query Express.get_req)) resp -> 
  let url = req##query##url in 
  Js.log url;
  Telegraf.Telegram.setWebhook 
    Webhook.telegram ~url
  |> Promise.catch (fun e -> Js.log e; Promise.resolve false)
  |> Promise.then_ (fun success ->
      Express.send resp (if success then "Updated" else "Failed!")
      |> Promise.resolve)
);

Express.post app webhook_path (fun (req:Telegraf.ctx Express.post_req) resp -> 
  Webhook.handler req##body resp);

Express.listen app 5000;
