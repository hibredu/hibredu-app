require('dotenv').config()

import './infrastructure/database'
import app from './infrastructure/server/app'

const port = 8080

app.listen(port, () => console.log(`🔥 Server Started at http://localhost:${port} 🔥`))