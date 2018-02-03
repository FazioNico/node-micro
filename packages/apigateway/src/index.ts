import * as express from 'express'
import * as morgan from 'morgan';
import { EventEmitter } from 'events';

import * as server  from "./server"
import { CONFIG } from "./config";

const mediator:EventEmitter = new EventEmitter()

// process.setMaxListeners(5)

console.log('--- API Gateway Service ---')

process.on('uncaughtException', (err) => {
  console.error('Unhandled Exception', err)
})

// process.on('uncaughtRejection', (err, promise) => {
//   console.error('Unhandled Rejection', err)
// })

// listen event on db ready
mediator.on('boot.ready', () => {
  // DI to conect repository with database
    server.start({
      port: CONFIG.serverSettings.port,
    })
    .then(config => {
      console.log(`Server started succesfully, running on port: ${CONFIG.serverSettings.port}  🎉`)
      console.log(`NODE_ENV: ${CONFIG.serverSettings.env_name}`)
      config.server.on('close', () => {
        console.log('[API GATEWAY] Server clse()')
      });
    })
    .catch(err => {
      console.log('[ERROR] ', err)
    });
})

// Server body ready... emit event to connect database with repository
mediator.emit('boot.ready')
