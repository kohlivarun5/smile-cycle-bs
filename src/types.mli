type quote = {
  for_ : string;
  dom : string;
  bid : float;
  ask : float;
}
type quotes = quote Js.Array.t Js.Promise.t

type arbitrage = {
  from : string;
  to_ : string;
  gain_perc : float;
  coin : string;
}
type arbs = arbitrage Js.Array.t Js.Promise.t

