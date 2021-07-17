import { Request, Response } from 'express'
import sayHello from '../../app/sayHello'

class HelloWorld {
    async index(_: Request, response: Response) {
        const message = sayHello();
        response.status(200).json({ message })
    }
}

export default new HelloWorld()