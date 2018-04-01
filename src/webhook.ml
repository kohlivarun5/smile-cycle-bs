let telegraf = Telegraf.client Credentials.Telegram.token  
let telegram = Telegraf.telegram telegraf
module Telegram = Telegraf.Telegram

let handler (ctx:Telegraf.ctx) resp = 
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
  let _ = Coindelta.get_prices () in
  Telegram.sendMessage 
    telegram 
    ~chat_id
    ~text:"Hello"
    ~send_message_params 
