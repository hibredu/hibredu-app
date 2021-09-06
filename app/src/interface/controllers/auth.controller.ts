import bcryptjs from 'bcryptjs'
import { Request, Response } from 'express'
import jwt from 'jsonwebtoken'
import { getRepository } from 'typeorm'
import Teacher from '../../app/entities/teacher.entity'

class AuthController {
    async authenticate(request: Request, response: Response) {
        const repository = await getRepository(Teacher)
        const { email, password } = request.body

        const teacher = await repository.findOne({
            email: email
        })

        if (!teacher) {
            return response.status(401).json({
                message: 'invalid teacher'
            })
        }

        const isValidPassword = await bcryptjs.compare(password, teacher.password ? teacher.password : '')

        if (!isValidPassword) {
            return response.status(401).json({
                message: 'invalid password'
            })
        }

        const token = await jwt.sign({ id: teacher.id, name: teacher.name }, 'secret', { expiresIn: '100d' }) // TODO: change expiresIn to config

        delete teacher.password

        return response.status(200).json({ 'message': 'token created', 'teacher': { id: teacher.id, name: teacher.name }, 'token': token })
    }
}

export default new AuthController()