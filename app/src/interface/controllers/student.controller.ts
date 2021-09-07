import { Request, Response } from 'express'
import Student from '../../app/entities/student.entity'
import StudentService from '../../app/services/student.service'

class StudentController {
    async getAll(request: Request, response: Response) {
        const teacherID = request.userId

        const allStudents = await StudentService.getAll(teacherID)
        response.status(200).json(allStudents)
    }

    async findOne(request: Request, response: Response) {
        const { id } = request.params
        let student: Student

        try {
            student = await StudentService.getById(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json(student)
    }

    async findDeliveryPercentage(request: Request, response: Response) {
        const { id } = request.params
        let deliveryPercentage: number

        try {
            deliveryPercentage = await StudentService.getDeliveryPercentage(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json({ deliveryPercentage })
    }
}

export default new StudentController()