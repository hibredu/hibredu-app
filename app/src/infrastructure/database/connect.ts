import { createConnections } from 'typeorm'

(async () => {
    const host = process.env.HOST_DB || 'localhost'
    const username = process.env.USERNAME_DB
    const password = process.env.PASSWORD_DB
    const database = process.env.DATABASE_DB

    await createConnections([{
        name: 'default',
        type: "mysql",
        host: host,
        port: 3306,
        username: username,
        password: password,
        database: database,
        entities: [
            __dirname + '../../app/entities/*.entity.{.js,.ts}',
            "src/app/entities/*.entity{.js,.ts}"
        ],
        migrations: ["src/database/migration/*{.js,.ts}"],
        synchronize: false
    }]).then(() => console.log('📦 Success Connected Database!'))
        .catch((error) => console.log("Unable to connect to the database" + error));
})();