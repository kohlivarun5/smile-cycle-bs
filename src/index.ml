let credentials = Coinbase.credentials 
                      ~apiKey:""
                      ~apiSecret:""
let client = Coinbase.client credentials 


let port = 3000
let hostname = "127.0.0.1"
let create_server http =
  let server = http##createServer begin fun [@bs] req resp ->
      Js.log req;
      Coinbase.ExchangeRates.get 
        client 
        (Coinbase.ExchangeRates.req ~currency:"BTC")
        (fun _ rates -> 
    
          let entries = Js.Dict.entries rates##data##rates in 
          Js.log(entries);
          let res = 
            Array.fold_left 
              (fun res (key,value) -> 
                  res ^ Printf.sprintf "\n %s : %s" key value )
              "" entries 
          in
          resp##statusCode #= 200;
          resp##setHeader "Content-Type" "text/plain";
          resp##_end res 
          );
      ()
    end
  in
  server##listen port hostname begin fun [@bs] () ->
    Js.log ("Server running at http://"^ hostname ^ ":" ^ Pervasives.string_of_int port ^ "/")
  end

let () = create_server Http_types.http
