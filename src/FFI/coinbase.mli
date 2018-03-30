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
