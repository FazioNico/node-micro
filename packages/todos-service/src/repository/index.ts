import * as mongoose from "mongoose";
import { todosSchema, ITodosModel } from "./repository.model";

interface IRepository {
  getAll:()=> Promise<any>,
  getById:()=> Promise<any>,
  disconnect:()=> any
}
const repository = (db:mongoose.Mongoose):IRepository => {
  // Define & export Mongoose Model with Interface
  const collection:mongoose.Model<ITodosModel> = db.model('todos', Object.create(todosSchema(db.Schema)));

  const getAll = () => {
    return new Promise((resolve, reject) => {
      collection.find((err, docs:ITodosModel[]) => {
  			if(err)  {
          reject(new Error('An error occured fetching all datas, err:' + err))
        };
        resolve({todos:docs})
  		});
    })
  }

  const getById = (id) => {
    return new Promise((resolve, reject) => {
      collection.findById(id, (err, doc:ITodosModel) => {
        if(err) {
          reject(new Error(`An error occured fetching a data with id: ${id}, err: ${err}`))
        };
        resolve({todo:doc});
      })
    })
  }

  const disconnect = () => {
    console.log('--- Mongoose connection close() ---')
    // TODO: close db.connection
    //return db.close()
  }

  return Object.create({
    getAll,
    getById,
    disconnect
  })
}

export const connect = (connection) => {
  return new Promise((resolve, reject) => {
    if (!connection) {
      reject(new Error('connection db not supplied!'))
    }
    resolve(repository(connection))
  })
}
