let telegraf = Telegraf.client Credentials.Telegram.token  
let telegram = Telegraf.telegram telegraf
module Telegram = Telegraf.Telegram

let arb () = 
  Arbitrage.coinbase_coindelta () 
  |> Js.Promise.then_ (fun arbs ->
      arbs 
      |> Formatting.format_arbs 
      |> Js.Promise.resolve)

let handler (ctx:Telegraf.ctx) resp = 
  Js.log ctx;
  let message = ctx##message in
  let message_id = message##message_id in 
  let text = message##text in 
  let from = message##from in 
  let chat = message##chat in 
  let chat_id = chat##id in 

  
  let send_message_params = 
    Telegram.send_message_params 
      ~parse_mode:"Markdown"
      ~reply_to_message_id:message_id
      ()
  in  

  let text_p = 
    match text with 
    | _ when (Js.String.startsWith "/arb" text) 
      -> arb ()
    | _ -> 
      Printf.sprintf "Unknown command: %s" text 
      |> Js.Promise.resolve 
  in
  text_p
  |> Js.Promise.then_ (fun text -> 
    Js.log ("txt",text);
    Telegram.sendMessage 
      telegram 
      ~chat_id
      ~text
      ~send_message_params
  )
  |> Js.Promise.then_ (fun _ -> Express.send resp "Ok!" |> Js.Promise.resolve)
