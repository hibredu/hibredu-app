import { Request, Response } from 'express'
import Student from '../../app/entities/student.entity'
import studentService from '../../app/services/student.service'
import StudentService from '../../app/services/student.service'

class StudentController {
    async getAll(request: Request, response: Response) {
        const teacherID = request.userId
        const studentsData = []

        const allStudents = await StudentService.getAll(teacherID)

        for (const student of allStudents) {
            const metrics = await this.getMetrics(student.id)

            studentsData.push({
                id: student.id,
                name: student.name,
                metrics
            })
        }

        response.status(200).json(studentsData)
    }

    async findOne(request: Request, response: Response) {
        const { id } = request.params
        let student: Student
        let studentData: any

        try {
            student = await StudentService.getById(parseInt(id))
            const metrics = await this.getMetrics(student.id);

            studentData = {
                id: student.id,
                name: student.name,
                activities: student.activitiesToStudents,
                metrics
            }
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json(studentData)
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

    private async getMetrics(studentId: number) {
        const deliveryPercentage = await studentService.getDeliveryPercentage(studentId)

        return {
            deliveredActivities: 0,// TODO: implement delivered activities
            deliveryPercentage: deliveryPercentage,
            hitRate: 0, // TODO: implement hit rate
            alerts: 0 // TODO: implement alerts
        }
    }
}

export default new StudentController()