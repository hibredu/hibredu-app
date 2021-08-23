require('dotenv').config()

import 'reflect-metadata'
import './infrastructure/database/connect'
import app from './infrastructure/server/app'

const PORT = 8080

app.listen(PORT, () => console.log(`🔥 Server Started at http://localhost:${PORT} 🔥`))