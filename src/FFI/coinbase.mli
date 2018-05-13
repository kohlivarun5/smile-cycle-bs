type credentials
external credentials :
  apiKey:string ->
  apiSecret:string ->
  credentials = "" [@@bs.obj]

type client
external client : credentials -> client = "Client" [@@bs.new] [@@bs.module "coinbase"]

module ExchangeRates : sig 
  type req
  external req : currency:string -> req = "" [@@bs.obj]

  type rates = < data : < currency : string; rates : string Js.Dict.t > Js.t > Js.t
  type error
  type callback = error -> rates -> unit 
  external get : client -> req -> callback -> unit = "getExchangeRates" [@@bs.send]
end 

type err 
type 'a empty = 'a Js.t
module Accounts : sig 
  
  type balance = <
    amount:string;
    currency:string;
  > Js.t

  type accounts = <
    id:       string;
    name:     string;
    primary : bool;
    currency: string;
    balance: balance;
    native_balance: balance;
  > Js.t Js.Array.t

  type callback = err -> accounts -> unit
  external get : client -> 'a empty -> callback -> unit = "getAccounts" [@@bs.send]

end
