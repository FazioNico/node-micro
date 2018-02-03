import * as express from 'express'
export * from './proxy';

export const apiRoutes = async (app:express.Application, options)=> {
  const {repo} = options;
  // Authentication
  app.use((req, res, next) => {
    // TODO: add authentication logic
    // (req.get('authorization') === process.env.TOKEN)
    //   ? next()
    //   : res.status(401).json({
    //     ok: false
    //   });
    next()
  })
}
