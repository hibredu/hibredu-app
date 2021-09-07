import { Request, Response } from 'express'
import classroomService from '../../app/services/classroom.service'
import { IClassroomResponse } from '../../app/shared/interfaces'

class ClassroomController {

    async getAll(request: Request, response: Response) {
        const classroomData = []

        try {
            const classrooms = await classroomService.getAll()

            for (const classroom of classrooms) {
                const metrics = await this.getMetrics(classroom.id)

                classroomData.push({
                    id: classroom.id,
                    name: classroom.name,
                    metrics
                })
            }

            response.status(200).json(classroomData)
        } catch (error) {
            response.status(500).json({ error: error.message })
        }
    }

    async findDeliveryPercentage(request: Request, response: Response) {
        const { id } = request.params
        let deliveryPercentage: number

        try {
            deliveryPercentage = await classroomService.getDeliveryPercentage(parseInt(id))
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json({ deliveryPercentage })
    }

    async getById(request: Request, response: Response) {
        const { id } = request.params
        let classroomData: IClassroomResponse

        try {
            const classroom = await classroomService.getById(parseInt(id));
            const metrics = await this.getMetrics(classroom.id);

            classroomData = {
                id: classroom.id,
                name: classroom.name,
                metrics
            }
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json(classroomData)
    }

    private async getMetrics(classroomId: number) {
        const deliveryPercentage = await classroomService.getDeliveryPercentage(classroomId)
        const attendancePercentage = await classroomService.getAttendancePercentage(classroomId)

        return {
            deliveredActivities: attendancePercentage,
            deliveryPercentage: deliveryPercentage,
            hitRate: 0, // TODO: implement hit rate
            alerts: 0 // TODO: implement alerts
        }
    }
}

export default new ClassroomController()