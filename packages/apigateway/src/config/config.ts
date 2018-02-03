export const dbSettings = {
  db: process.env.DB || 'test',
  user: process.env.DB_USER || '',
  pass: process.env.DB_PASS || '',
  repl: process.env.DB_REPLS || 'rs1',
  servers: (process.env.DB_SERVERS) ? process.env.DB_SERVERS.split(' ') : [
    'localhost:27017'
  ],
}

export const serverSettings = {
  port: process.env.PORT || 3001,
  env_name: process.env.NODE_ENV || 'not work'
  //ssl: require('./ssl')
}
