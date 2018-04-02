let calc_arbs (from,buy_fees_perc,arbs1) (to_,arbs2) usd_inr = 
    arbs1 
    |> Js.Array.map (fun {Types.for_;dom=_;bid=_;ask} ->
        let bid_opt = 
          Js.Array.find 
            (fun (q:Types.quote) -> 
              (Js.String.toLowerCase for_) = (Js.String.toLowerCase q.for_))
            arbs2
        in
        match bid_opt with 
        | None -> None 
        | Some {bid;_} -> 
            let orig_notional = 100. in 
            let notional = orig_notional -. buy_fees_perc in
            let buy = notional /. ask in 
            let sell = buy *. bid in 
            let buy_flow = orig_notional *. usd_inr in 
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
  let coinbase = Coinbase_api.get_prices () in 
  let coindelta = Coindelta.get_prices () in 
  let usd_inr = Forex.get_prices "USD" "INR" in
  Js.Promise.all3 (coinbase,coindelta,usd_inr) 
  |> Js.Promise.then_ (fun (coinbase,coindelta,usd_inr) ->
      calc_arbs ("Coinbase",Coinbase_api.buy_fees_perc,coinbase) ("Coindelta",coindelta) usd_inr
      |> Js.Promise.resolve)

let coinbase_koinex () : Types.arbs_p = 
  let coinbase = Coinbase_api.get_prices () in 
  let koinex = Koinex.get_prices () in 
  let usd_inr = Forex.get_prices "USD" "INR" in
  Js.Promise.all3 (coinbase,koinex,usd_inr) 
  |> Js.Promise.then_ (fun (coinbase,koinex,usd_inr) ->
      calc_arbs ("Coinbase",Coinbase_api.buy_fees_perc,coinbase) ("Koinex",koinex) usd_inr
      |> Js.Promise.resolve)
