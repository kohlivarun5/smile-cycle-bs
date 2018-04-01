let calc_arbs (from,arbs1) (to_,arbs2) = 
    arbs1 
    |> Js.Array.map (fun {Types.for_;dom;bid=_;ask} ->
        let bid_opt = 
          Js.Array.find 
            (fun (q:Types.quote) -> for_ = q.for_)
            arbs2
        in
        match bid_opt with 
        | None -> None 
        | Some {bid;_} -> 
            let notional = 1000. in 
            let buy = notional /. ask in 
            let sell = buy *. bid in 
            let buy_flow = notional *. 64. (* TODO *) in 
            let profit = sell -. buy_flow in 
            if profit < 0. 
            then None 
            else Some Types.{
              gain_perc = profit *. 100. /. buy_flow;
              coin = for_;
            })
      |> Js.Array.filter Js.Option.isSome
      |> Js.Array.map Js.Option.getExn 
      |> (fun arbs -> {Types.from;to_;arbs})


let coinbase_coindelta () : Types.arbs_p = 
  Js.log "Calculating";
  let coinbase = Coinbase_api.get_prices () in 
  let coindelta = Coindelta.get_prices () in 
  Js.Promise.all2 (coinbase,coindelta) 
  |> Js.Promise.then_ (fun (coinbase,coindelta) ->
      calc_arbs ("Coinbase",coinbase) ("Coindelta",coindelta)
      |> Js.Promise.resolve)
