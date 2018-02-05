import * as express from 'express'
import * as fetch from "node-fetch";

interface IRequestOptions {
    method: string
    , headers?: {}        // request header. format {a:'1'} or {b:['1','2','3']}
    , redirect?: string // set to `manual` to extract redirect headers, `error` to reject redirect
    , follow?: number         // maximum redirect count. 0 to not follow redirect
    , timeout?: number         // req/res timeout in ms, it resets on redirect. 0 to disable (OS limit applies)
    , compress?: boolean     // support gzip/deflate content encoding. false to disable
    , size?: number            // maximum response body size in bytes. 0 to disable
    , body: any        // request body. can be a string, buffer, readable stream
    , agent?: null        // http.Agent instance, allows custom proxy, certificate etc.
}
export const proxyRoutes = async (app:express.Application, options)=> {
  const {repo} = options;

  app.use((req, res, next) => {
    // TODO: get rte from network memory staging or redis db. Using repo.db
    // let rtes:{path:string, host:string}[] = [
    //   {path:'/users', host:'http://users:3000'},
    //   {path:'/todos', host:'http://todos:3001'}
    // ];
    // if(!rtes.filter(r => r.path ===`/${req.url.split('/')[1]}`)[0]){
    //   next()
    //   return;
    // }
    // const host:string = rtes.filter(r => r.path ===`/${req.url.split('/')[1]}`)[0].host;

    const path:string = req.url.split('/').filter(param => param !='').splice(1, 1).join('/');
    const token: string = req.get('x-access-token') || req.get('authentication') || req.get('authorization') || undefined;

    let requestOptions:IRequestOptions = {
      method: req.method.toUpperCase(),
      body: req.body ,
      headers:{
        'Content-type': 'application/json',
        'x-access-token': token
      },
      //compress: true
    }

    repo.find(req.url.split('/')[1])
        .then(result=> {
          console.log('repos find -->', `http://${result.label}:${result.port}/${path}`)
          if(result){
            return fetch(`http://${result.label}:${result.port}/${path}`, requestOptions)
            .then((response)=> response.json())
            .then((json)=> res.status(200).json(json))
            .catch((err) => {
              console.log("Error requestAPI: " + err.message);
              res.status(500).json(err)
            })
          }
          next()
          return;
        })
        .catch((err) => {
          console.log("Error Route not existing: " + err.message);
          res.status(500).json({code:500, msg: 'Error Route not existing or unactive: '+`/${req.url.split('/')[1]}/${path}`})
        })

  })
}
