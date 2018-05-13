open Index

let () = 
  let app = Express.app () in
  Express.use_json app (BodyParser.json ());
  Express.use_urlencoded app (BodyParser.urlencoded (BodyParser.urlencoded_params ~extended:(Js.Boolean.to_js_boolean true)));
  Express.get app "/" (fun _ resp -> Express.send resp "Hello");
  Express.get app "/set_webhook" set_webhook;
  Express.post app "/webhook" webhook;
  Express.listen app 8080;

