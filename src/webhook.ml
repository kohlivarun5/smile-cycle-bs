let callback (ctx:Telegraf.ctx) = 
  Js.log ctx;
  ctx##reply "Pong"
