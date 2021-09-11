require('dotenv').config()
import loggerPino from './loggerPino'

import 'reflect-metadata'
import './infrastructure/database/connect'
import app from './infrastructure/server/app'

const PORT = process.env.PORT || 8080

app.listen(PORT, () => loggerPino.info(`🔥 Server Started at http://localhost:${PORT} 🔥`))