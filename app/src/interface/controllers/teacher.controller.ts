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
        let teacher = request.body

        try {
            teacher = await teacherService.create(teacher)

            return response.status(200).json({ 'message': 'user created', 'data': teacher })
        } catch (error) {
            return response.status(500).json({
                message: error.message
            })
        }

    }

    async update(request: Request, response: Response) {
        const { id } = request.params
        let teacher: ITeacher = request.body

        try {
            teacher = await teacherService.update(parseInt(id), teacher)
            delete teacher.password
            return response.status(200).json({ 'message': 'user updated', 'teacher': teacher })
        } catch (error) {
            return response.status(500).json({
                message: error.message
            })
        }
    }

}

export default new TeacherController()