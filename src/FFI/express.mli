


type app
external app : unit -> app = "express" [@@bs.module]
external json : unit -> app = "" [@@bs.val] [@@bs.module "express"]
external listen : app -> int -> unit = "" [@@bs.send]
type req
type res
external get : app -> string -> (req -> res -> res) -> unit = "" [@@bs.send]
external send : res -> string -> res = "" [@@bs.send]

external use_json : app -> BodyParser.json -> unit = "use" [@@bs.send]
external use_urlencoded : app -> BodyParser.urlencoded -> unit = "use" [@@bs.send]
