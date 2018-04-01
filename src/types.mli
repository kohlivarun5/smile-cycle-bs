type quote = {
  for_ : string;
  dom : string;
  bid : float;
  ask : float;
}
type quotes = quote Js.Array.t
type quotes_p = quotes Js.Promise.t

type arb = {
  gain_perc : float;
  coin : string;
}

type arbs = {
  from : string;
  to_ : string; 
  arbs : arb array;
}
type arbs_p = arbs Js.Promise.t
