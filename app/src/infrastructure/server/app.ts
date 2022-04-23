import express from 'express'
import cors from 'cors'
import morgan from 'morgan'
import routes from '../../interface/routes/routes'

class AppController {
    app: express.Express

    constructor() {
        this.app = express()
        
        this.middlewares()
        this.routes()
    }

    middlewares() {
        this.app.use(cors())
        this.app.use(express.json())
        this.app.use(express.urlencoded({ extended: true }))
        this.app.use(morgan('dev'))
    }

    routes() {
        this.app.use(routes)
    }
}

export default new AppController().app