let webhook_path = "/webhook"
let webhook (req:Telegraf.ctx Express.post_req) resp = Webhook.handler req##body resp

type url_query = < url : string >
let set_webhook (req:(url_query Express.get_req)) resp =
  let url = req##query##url in 
  Telegraf.Telegram.setWebhook 
    Webhook.telegram ~url
  |> Js.Promise.catch (fun e -> Js.log e; Js.Promise.resolve false)
  |> Js.Promise.then_ (fun success ->
      Express.send resp (if success then "Updated" else "Failed!")
      |> Js.Promise.resolve)

let () = 
  let app = Express.app () in
  Express.use_json app (BodyParser.json ());
  Express.use_urlencoded app (BodyParser.urlencoded (BodyParser.urlencoded_params ~extended:(Js.Boolean.to_js_boolean true)));
  Express.get app "/" (fun _ resp -> Express.send resp "Hello");
  Express.get app "/set_webhook" set_webhook;
  Express.post app webhook_path webhook;
  Express.listen app 8080;
