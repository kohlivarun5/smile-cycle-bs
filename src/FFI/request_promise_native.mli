external request : 
  string -> 
    'a Js.Promise.t = "request-promise-native" [@@bs.module] 

type options
external options : 
  ?json:Js.boolean ->
  ?headers:string Js.Dict.t ->
  uri:string ->
  options = "" [@@bs.obj]
  
external request_opts : options -> 'a Js.Promise.t = "request-promise-native" [@@bs.module] 
