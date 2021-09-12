import { Request, Response } from 'express'
import { ITeacher } from '../../app/entities/teacher.entity'
import teacherService from '../../app/services/teacher.service'

class TeacherController {

    async getAll(request: Request, response: Response) {
        try {
            const teachers = await teacherService.getAll()
            return response.status(200).json(teachers)
        } catch (error) {
            return response.status(500).json({
                message: error.message
            })
        }
    }

    async create(request: Request, response: Response) {
        const { name, email, password, phone, school_id } = request.body

        let teacher: ITeacher = {
            name,
            email,
            password,
            phone,
            school_id
        }

        try {
            teacher = await teacherService.create(teacher)
            delete teacher.password
            return response.status(200).json({ 'message': 'user created', 'teacher': teacher })
        } catch (error) {
            return response.status(500).json({
                message: error.message
            })
        }

    }
}

export default new TeacherController()