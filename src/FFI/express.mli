


type app
external app : unit -> app = "express" [@@bs.module]
external listen : app -> int -> unit = "" [@@bs.send]

type res

type 'a get_req = < 
  query : 'a Js.t;
  protocol : string;
  get : string -> string [@bs.meth];
> Js.t
external get : app -> string -> ('a get_req -> res -> 'b) -> unit = "" [@@bs.send]

type 'a post_req = < body : 'a Js.t > Js.t
external post : app -> string -> ('a post_req -> res -> 'b) -> unit = "" [@@bs.send]

external send : res -> string -> res = "" [@@bs.send]

external use_json : app -> BodyParser.json -> unit = "use" [@@bs.send]
external use_urlencoded : app -> BodyParser.urlencoded -> unit = "use" [@@bs.send]

external use_callback : app -> ('a -> 'b -> 'c) -> unit = "use" [@@bs.send]
