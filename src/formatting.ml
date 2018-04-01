let format_arbs ({from;to_;arbs}:Types.arbs) : string = 
  let str = 
    arbs |> Js.Array.map (fun {Types.coin;gain_perc} -> 
      Printf.sprintf 
        " - %s : *%.4g%%*" 
        (Js.String.toUpperCase coin)
        gain_perc
    )
  in  
  let str = 
    str |> Array.to_list |> String.concat "\n"
  in 
  let text = 
    Printf.sprintf "_%s -> %s_\n%s" from to_ str 
  in 
  Js.log text;
  text
