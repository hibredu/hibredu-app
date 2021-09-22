import { Request, Response } from 'express'
import Student from '../../app/entities/student.entity'
import alertService from '../../app/services/alert.service'
import studentService from '../../app/services/student.service'

class StudentController {
    async getAll(request: Request, response: Response) {
        const teacherID = request.userId
        const studentsData = []

        const allStudents = await studentService.getAll(teacherID)
        console.log("========================= All Students =========================")
        console.log(allStudents)

        for (const student of allStudents) {
            const metrics = await this.getMetrics(student.id)

            studentsData.push({
                id: student.id,
                name: student.name,
                subjects: student.subjects.map(subject => subject.school_subject),
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
            student = await studentService.getById(parseInt(id))
            const metrics = await this.getMetrics(student.id);

            studentData = {
                id: student.id,
                name: student.name,
                activities: student.activitiesToStudents,
                alerts: student.alerts,
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
            deliveryPercentage = await studentService.getDeliveryPercentage(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json({ deliveryPercentage })
    }

    private async getMetrics(studentId: number) {
        const deliveredActivities = await studentService.getDeliveredActivities(studentId)
        const deliveryPercentage = await studentService.getDeliveryPercentage(studentId)
        const hitRate = await studentService.getHitRate(studentId)
        const alerts = await (await alertService.getByStudent(studentId)).length

        return {
            deliveredActivities: deliveredActivities || 0,
            deliveryPercentage: deliveryPercentage || 0,
            hitRate: hitRate || 0,
            alerts: alerts || 0
        }
    }
}

export default new StudentController()
