(** A simple binding to node [http] module *)
type req 

class type _resp = object 
  method statusCode : int [@@bs.set]
  method setHeader : string -> string -> unit 
  method _end : string -> unit 
end [@bs]

type resp = _resp Js.t 

class type _server = object 
  method listen : int -> string -> (unit -> unit [@bs]) -> unit 
end [@bs]
type server = _server Js.t 

class type _http  = object 
  method createServer : (req  ->  resp  -> unit [@bs] ) ->  server
end [@bs]

type http = _http Js.t 


external http : http  = ""  [@@bs.module]
