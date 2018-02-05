export const dbSettings = {
  host: 'redis'
}

export const serverSettings = {
  port: process.env.PORT || 3001,
  env_name: process.env.NODE_ENV || 'not work'
  //ssl: require('./ssl')
}
