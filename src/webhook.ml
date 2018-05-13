let telegraf = Telegraf.client Credentials.Telegram.dev_token 
let telegram = Telegraf.telegram telegraf
module Telegram = Telegraf.Telegram

let coinbase =  Coinbase.credentials 
                  ~apiKey:Credentials.Coinbase.apiKey
                  ~apiSecret:Credentials.Coinbase.apiSecret 
                |> Coinbase.client

let reply ?reply_to_message_id ~chat_id text = 
  let send_message_params = 
    Telegram.send_message_params 
      ?reply_to_message_id 
      ~parse_mode:"Markdown"
      ()
  in  
  text
  |> Js.Promise.then_ (fun text -> 
    Telegram.sendMessage 
      telegram 
      ~chat_id
      ~text
      ~send_message_params)
  |> Js.Promise.then_ (fun _ -> Js.Promise.resolve "Ok!")

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

let coinbase_balance () = 
  Js.Promise.make (fun ~resolve ~reject:_ -> 
    Coinbase.Accounts.get coinbase (Js.Obj.empty ()) (fun err accounts -> 
      if (not (Js.testAny err))
      then (resolve (Js.Result.Error err))[@bs]
      else (resolve (Js.Result.Ok accounts))[@bs])
  )
  |> Js.Promise.then_ (fun accounts_result -> 
      (match accounts_result with 
      | Js.Result.Error err -> 
        Js.log err;
        "Failed to get account info!"
      | Js.Result.Ok accounts ->
        let balances = 
          Js.Array.map (fun account -> 
            {
              Types.crypto={
                amount=Js.Float.fromString account##balance##amount;
                currency=account##balance##currency;
              };
              Types.native={
                amount=Js.Float.fromString account##native_balance##amount;
                currency=account##native_balance##currency;
              };
            }
          ) accounts
        in
        Formatting.format_balance balances)
      |> Js.Promise.resolve)


let handler (ctx:Telegraf.ctx) resp = 
  let message = ctx##message in
  let message_id = message##message_id in 
  let text = message##text in 
  let chat = message##chat in 
  let chat_id = chat##id in 

  (match text with 
  | _ when (Js.String.startsWith "/arb" text) 
    -> arb ()
  | _ when (Js.String.startsWith "/coinbase_balance" text) 
    -> coinbase_balance ()
  | _ -> 
    Printf.sprintf "Unknown command: %s" text 
    |> Js.Promise.resolve)
  |> reply ~reply_to_message_id:message_id ~chat_id 
  |> Js.Promise.then_ (fun msg -> Express.send resp msg |> Js.Promise.resolve)
