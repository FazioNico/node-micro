import * as redis from "redis";

export const connect = (options, mediator) => {
  // server body ready... let's try to connect to database.
  mediator.once('boot.ready', () => {
    if(!options){
      new Error('Unable to connect redis db. No config options')
      mediator.emit('db.error', 'Unable to connect redis db. No config options')
    }
    const db:redis.RedisClient = redis.createClient(options);

    db.on('connect', ()=>{
      console.log("Redis default connection is open");
      // database is connected and ready. Emit an event to notifier server app.
      mediator.emit('db.ready', <redis.RedisClient>db)
    });
    db.on('end', ()=>{
      console.log("Redis default connection is disconnected");
    });
    db.on('error', (err)=>{
      console.log("Redis default connection has occured "+err+" error");
      mediator.emit('db.error', err)
    });

    process.on('SIGINT', ()=>{
      db.quit(()=>{
        console.log("Redis default connection is disconnected due to application termination");
        process.exit(0);
      });
    });
  })
}
