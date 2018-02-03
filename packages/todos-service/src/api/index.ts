import * as express from 'express'

export const apiRoutes = async (app:express.Application, options)=> {
  const {repo} = options;

  await app.get('/todos', async (req:express.Request, res:express.Response, next:express.NextFunction) => {
    await repo.getAll()
      .then(todos => {
        res.status(200).json(todos)
      })
      .catch(next)
  })

  await app.get('/todos/:id', async(req:express.Request, res:express.Response, next:express.NextFunction) => {
    await repo.getById(req.params.id)
      .then(todo => {
        res.status(200).json(todo)
      })
      .catch(next)
  })

  await app.get('/test', async(req:express.Request, res:express.Response, next:express.NextFunction) => {
      res.status(200).json('todo')
  })
}
