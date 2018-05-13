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
    str |> Array.to_list |> (function [] -> " - No arbitrage found!" | l -> String.concat "\n" l)
  in 
  let text = 
    Printf.sprintf "_%s -> %s_\n%s" from to_ str 
  in 
  text 

let format_balance (amounts:Types.balances) = 
  match amounts with 
  | [||] -> "No balance found!"
  | amounts -> 
    amounts
    |> Js.Array.sortInPlaceWith (fun
      {Types.native={amount=am1;_};_} {Types.native={amount=am2;_};_} ->
      Pervasives.compare am2 am1)
    |> Js.Array.map (fun ({crypto;native}:Types.balance) ->
        Printf.sprintf 
          " - *%.2f %s* (%.2f %s)" 
          native.amount
          native.currency
          crypto.amount
          crypto.currency)
    |> Array.to_list
    |> String.concat "\n"


