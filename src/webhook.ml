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
      |>  Array.to_list |> String.concat "\n"
      |> Js.Promise.resolve)

let handle_arb ?reply_to_message_id ~chat_id = 
  let send_message_params = 
    Telegram.send_message_params 
      ?reply_to_message_id 
      ~parse_mode:"Markdown"
      ()
  in  
  arb () 
  |> Js.Promise.then_ (fun text -> 
    Telegram.sendMessage 
      telegram 
      ~chat_id
      ~text
      ~send_message_params)
  |> Js.Promise.then_ (fun _ -> Js.Promise.resolve "Ok!")

let handler (ctx:Telegraf.ctx) resp = 
  let message = ctx##message in
  let message_id = message##message_id in 
  let text = message##text in 
  let chat = message##chat in 
  let chat_id = chat##id in 

  (match text with 
  | _ when (Js.String.startsWith "/arb" text) 
    -> handle_arb ~reply_to_message_id:message_id ~chat_id 
  | _ -> 
    Printf.sprintf "Unknown command: %s" text 
    |> Js.Promise.resolve)
  |> Js.Promise.then_ (fun msg -> Express.send resp msg |> Js.Promise.resolve)
