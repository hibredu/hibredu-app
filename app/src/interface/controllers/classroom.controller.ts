import { Request, Response } from 'express'
import classroomService from '../../app/services/classroom.service'
import { IClassroomResponse } from '../../app/shared/interfaces'

class ClassroomController {

    async getAll(request: Request, response: Response) {
        try {
            const classrooms = await classroomService.getAll()
            response.status(200).json(classrooms)
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
        let attendancePercentage: number
        let deliveryPercentage: number
        let classroomData: IClassroomResponse

        try {
            const classroom = await classroomService.getById(parseInt(id));
            deliveryPercentage = await classroomService.getDeliveryPercentage(parseInt(id))
            attendancePercentage = await classroomService.getAttendancePercentage(parseInt(id))

            classroomData = {
                id: classroom.id,
                name: classroom.name,
                metrics: {
                    deliveredActivities: attendancePercentage,
                    deliveryPercentage: deliveryPercentage,
                    hitRate: 0, // TODO: implement hit rate
                    alerts: 0 // TODO: implement alerts
                }
            }
        } catch (error) {
            response.status(500).json({ error: error.message })
        }

        response.status(200).json(classroomData)
    }
}

export default new ClassroomController()