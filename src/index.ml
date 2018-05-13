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

