import { Request, Response } from 'express'
import { getRepository } from 'typeorm'
import jwt from 'jsonwebtoken'
import { Teacher } from '../../app/entities/teacher.entity'
import bcryptjs from 'bcryptjs'
import authService from '../../app/services/auth.service'

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

    async createUser(request: Request, response: Response) {
        const { name, email, password, phone } = request.body

        const teacher = new Teacher()
        teacher.name = name
        teacher.email = email
        teacher.password = password
        teacher.phone = phone

        try {
            await authService.createTeacher(teacher)
            delete teacher.password
            return response.status(200).json({ 'message': 'user created', 'teacher': teacher })
        } catch (error) {
            return response.status(500).json({
                message: error.message
            })
        }

    }
}

export default new AuthController()