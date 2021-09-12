import { createConnections } from 'typeorm'
import logger from '../../loggerPino';

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
            `${__dirname}/../../**/*.entity.{ts,js}`
        ],
        migrations: ["src/database/migration/*{.js,.ts}"],
        synchronize: false
    }]).then(() => logger.info('📦 Success Connected Database!'))
        .catch((error) => logger.error("Unable to connect to the database" + error));
})();