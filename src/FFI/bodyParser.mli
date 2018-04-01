type json 
external json : unit -> json = "" [@@bs.module "body-parser"] [@@bs.val] 

type urlencoded_params
external urlencoded_params : extended:Js.boolean -> urlencoded_params = "" [@@bs.obj]

type urlencoded
external urlencoded : urlencoded_params -> urlencoded = "" [@@bs.module "body-parser"] [@@bs.val] 
