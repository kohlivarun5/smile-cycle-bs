type client 
external client : string -> client = "telegraf" [@@bs.module] [@@bs.new]

type message = <
  message_id : int ; 
  from : <
    id : int;
    is_bot : bool;
    first_name : string;
    last_name : string;
    username : string;
  > Js.t;
  chat : < id : int > Js.t;
  text : string;
  reply_to_message : message Js.t option;
> Js.t

type ctx = <
  message : message;
  reply : string -> bool Js.Promise.t [@bs.meth]
> Js.t


module Telegram : sig 
  type client 
  external setWebhook : 
    client -> url:string -> 
    bool Js.Promise.t = "" [@@bs.send] 

  type send_message_params
  external  send_message_params :
    ?parse_mode:string -> 
    ?reply_to_message_id:int -> 
    unit -> send_message_params = "" [@@bs.obj]

  external sendMessage : 
    client ->
    chat_id:int -> 
    text:string -> 
    ?send_message_params:send_message_params ->
    message Js.Promise.t = "" [@@bs.send]
end
external telegram : client -> Telegram.client = "" [@@bs.get]
