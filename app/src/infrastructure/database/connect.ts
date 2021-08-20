import { createConnection } from 'typeorm'

const host = process.env.HOST
const username = process.env.USERNAME
const password = process.env.PASSWORD
const database = process.env.DATABASE

createConnection({
    name: "default",
    type: "mysql",
    host: host,
    username: username,
    password: password,
    database: database,
    entities: ["src/app/models/*.entity{.js,.ts}"],
    //migrations: ["src/database/migration/*{.js,.ts}"],
    synchronize: false
}).then(() => console.log('📦 Success Connected Database!'))
