
import {dbSettings, serverSettings}  from './config'
import * as db from './redis'

export const CONFIG = Object.assign({}, {dbSettings, serverSettings, db})
