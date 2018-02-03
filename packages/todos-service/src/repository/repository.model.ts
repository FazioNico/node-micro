import * as mongoose from 'mongoose';

export const todosSchema = (Schema) => ({
  todoSchema: new mongoose.Schema({
    title: {
        type: String,
        required: true,
        match: /(?=.*[a-zA-Z])(?=.*[0-9]+).*/,
        minlength: 2
    },
    uid: {
        type: String,
        require: true
    },
    statut: {
       type: Boolean,
       required: false,
       default: false
    },
  })
})

export const todosSchema1:mongoose.Schema = new mongoose.Schema({
  title: {
      type: String,
      required: true,
      match: /(?=.*[a-zA-Z])(?=.*[0-9]+).*/,
      minlength: 2
  },
  uid: {
      type: String,
      require: true
  },
  statut: {
     type: Boolean,
     required: false,
     default: false
  },
  // pre: ()=> {
  //
  // },
});

// todosSchema(mongoose).todoSchema.pre('save', (next)=> {
// 	next();
// });

export interface ITodosModel extends mongoose.Document {
  title: string,
  uid:string,
  statut: boolean
}
