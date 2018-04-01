let telegraf = Telegraf.client Credentials.Telegram.dev_token 
let telegram = Telegraf.telegram telegraf
module Telegram = Telegraf.Telegram

let arb () = 
  [|
    Arbitrage.coinbase_coindelta ();
    Arbitrage.coinbase_koinex ();
  |]
  |> Js.Promise.all
  |> Js.Promise.then_ (fun arbs_arr -> 
      Js.Array.map Formatting.format_arbs arbs_arr 
      |>  Array.to_list |> String.concat "\n "
      |> Js.Promise.resolve)

let handler (ctx:Telegraf.ctx) resp = 
  let message = ctx##message in
  let message_id = message##message_id in 
  let text = message##text in 
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
    Telegram.sendMessage 
      telegram 
      ~chat_id
      ~text
      ~send_message_params
  )
  |> Js.Promise.then_ (fun _ -> Express.send resp "Ok!" |> Js.Promise.resolve)
