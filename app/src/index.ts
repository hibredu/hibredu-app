import app from './infrastructure/server/app'

const port = 3000

app.listen(port, () => console.log(`🔥 Server Started at http://localhost:${port} 🔥`))