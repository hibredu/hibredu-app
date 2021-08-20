import { Request, Response } from 'express'
import StudentService from '../../app/services/student.service'

class StudentController {
    async getAll(_: Request, response: Response) {
        const allStudents = await StudentService.getAll()
        response.status(200).json(allStudents)
    }

    async findOne(request: Request, response: Response) {
        const { id } = request.params
        let student
        
        try {
            student = await StudentService.getOne(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json(student)
    }
}

export default new StudentController()