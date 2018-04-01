type client 
external client : string -> client = "telegraf" [@@bs.module] [@@bs.new]

type message
type ctx = <
  message : message;
  reply : string -> bool Js.Promise.t [@bs.meth]
> Js.t

external webhookCallback : 
  client -> string -> 
  (ctx -> 'a Js.Promise.t) -> 'b = "" [@@bs.send]

module Telegram : sig 
  type client 
  external setWebhook : 
    client -> url:string -> 
    bool Js.Promise.t = "" [@@bs.send]
end
external telegram : client -> Telegram.client = "" [@@bs.get]
