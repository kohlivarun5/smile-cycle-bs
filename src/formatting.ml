let format_arbs ({from;to_;arbs}:Types.arbs) : string = 
  let str = 
    arbs 
    |> Js.Array.sortInPlaceWith (fun
      {Types.gain_perc=gain_perc1;_} {Types.gain_perc=gain_perc2;_} -> 
      Pervasives.compare gain_perc2 gain_perc1)
    |> Js.Array.map (fun {Types.coin;gain_perc} -> 
      Printf.sprintf 
        " - %s : *%.2f%%*" 
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
  text
