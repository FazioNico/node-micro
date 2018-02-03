import * as express from 'express'
import * as  http from 'http'

export const proxyRoutes = async (app:express.Application, options)=> {
  const {repo} = options;

  app.use((req, res, next) => {
    // TODO: get rte from network memory staging or redis db. Using repo.db
    let rtes:{path:string, host:string}[] = [
      {path:'/users', host:'http://users:3000'},
      {path:'/todos', host:'http://todos:3001'}
    ];
    if(!rtes.filter(r => r.path ===`/${req.url.split('/')[1]}`)[0]){
      next()
      return;
    }
    const host:string = rtes.filter(r => r.path ===`/${req.url.split('/')[1]}`)[0].host;
    const path:string = req.url.split('/').filter(param => param !='').splice(1, 1).join('/');

    http[req.method.toLowerCase()](
      `${host}/${path}`, // proxy url
      (response) => {
        let data = '';
        // A chunk of data has been recieved.
        response.on('data', (chunk) => {
          data += chunk;
        });
        response.on('end', () => {
          console.log('http reverse proxy response: ', data);
          res.status(200).json(JSON.parse(data))
        });
      }
    )
    .on("error", (err) => {
      console.log("Error requestAPI: " + err.message);
      res.status(500).json(err)
    });
  })
}
