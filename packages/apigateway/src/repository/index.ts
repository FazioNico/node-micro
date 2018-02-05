import * as redis from "redis";

export interface IRepository {
  setAll:(data)=> Promise<any>,
  find:(key)=> Promise<any>,
  add:(data)=> Promise<any>,
  remove:(data)=> any
}
const repository = (db:redis.RedisClient):IRepository => {
  const collection:string = 'ROUTES'

  // const findAll = async(key) => await db.get(key)

  const setAll:IRepository['setAll'] = (data)=> {
    return new Promise((resolve,reject)=> {
      db.set(collection, JSON.stringify(data), (err,res)=>
        (err)
          ? reject(err)
          : resolve(res)
      )
    })
    .then(_=> {
      return new Promise((resolve, reject)=> {
        db.get(collection, (err, result)=> {
          resolve(JSON.parse(result))
        })
      })
    })
  }

  const find = (path) => {
    return new Promise((resolve,reject)=> {
      db.get(collection,(err,res)=>
        (err)
          ? reject(null)
          : resolve(res)
      )
    })
    .then((res:string)=>{
        if(res){
          return (<any[]>JSON.parse(res)).filter(r => r.label === path)[0]
        }
        else {
          return null
        }
    })
  }

  const add = (data) =>    {
    return new Promise((resolve,reject)=> {
      db.get(collection,(err,res)=>
        (err)
          ? reject(err)
          : resolve(res)
      )
    })
    .then((res:any)=> {
      let datasToStore = (<any[]>JSON.parse(res));
      if(datasToStore.find(r=>r.id === data.id)){
        datasToStore = datasToStore.filter(r=>r.id !== data.id)
      }
      datasToStore.push({
        id: data.id,
        label: data.label,
        port: data.port || ''
      });
      return setAll(datasToStore)
    })

  }


  const remove = (id) => {
    return new Promise((resolve,reject)=> {
      db.get(collection,(err,res)=>
        (err)
          ? reject(err)
          : resolve(res)
      )
    })
    .then((res:any)=> {
      console.log('remove id ->', id)
      let datasToStore = (<any[]>JSON.parse(res)).filter(r => r.id != id);
      return  setAll(datasToStore)
    })
  }

  const disconnect = async() => {
    await db.quit()
  }

  return Object.create({
    setAll,
    find,
    remove,
    add
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
