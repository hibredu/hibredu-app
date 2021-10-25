import { Request, Response } from "express"
import alertService from "../../app/services/alert.service"
import overviewService from "../../app/services/overview.service"

class OverviewController {

    async getClassroom(request: Request, response: Response) {
        const teacherId = parseInt(request.userId)

        const deliveredActivities = await (await overviewService.getDeliveredActivitiesByTeacher(teacherId)).length
        const deliveryPercentage = await overviewService.getDeliveryPercentageByTeacher(teacherId)
        const hitRate = await overviewService.getHitRateByTeacher(teacherId)
        const alerts = await (await alertService.getByTeacher(teacherId)).length

        response.status(200).json({
            deliveredActivities: deliveredActivities,
            deliveryPercentage: deliveryPercentage,
            hitRate: hitRate,
            alerts: alerts
        })
    }

    async getAttendance(request: Request, response: Response) {
        const teacherId = parseInt(request.userId)

        const attendances = await overviewService.getAttendancesByTeacher(teacherId)

        response.status(200).json(attendances)
    }

    async getActivities(request: Request, response: Response) {
        const teacherId = parseInt(request.userId)

        const activities = await overviewService.getActivitiesByTeacher(teacherId)

        response.status(200).json(activities)
    }

    async getAlerts(request: Request, response: Response) {
        const teacherId = parseInt(request.userId)

        const alerts = await alertService.getByTeacher(teacherId)

        response.status(200).json(alerts)
    }

    async getAttendanceActivities(request: Request, response: Response) {
        const teacherId = parseInt(request.userId)

        const deliveredActivities = await overviewService.getDeliveredActivitiesByTeacher(teacherId)
        const attendance = await overviewService.getAttendanceByTeacher(teacherId)

        const attendance_delivered = await overviewService.getAttendanceActivities(deliveredActivities, attendance)
        const orderned_by_date = attendance_delivered.sort((a, b) => (a.date > b.date) ? 1 : -1)

        response.status(200).json(orderned_by_date)
    }

    async getStudentAttendanceActivities(request: Request, response: Response) {
        const studentId = parseInt(request.params.id)
        const teacherId = parseInt(request.userId)

        //const deliveredActivities = []
        const deliveredActivities = await overviewService.getDeliveredActivitiesByStudent(studentId)
        const attendance = await overviewService.getAttendanceByStudent(teacherId, studentId)

        const attendance_delivered = await overviewService.getAttendanceActivities(deliveredActivities, attendance)
        const orderned_by_date = attendance_delivered.sort((a, b) => (a.date > b.date) ? 1 : -1)

        response.status(200).json(orderned_by_date)
    }
    
    async getClassroomAttendanceActivities(request: Request, response: Response) {
        const classroomId = parseInt(request.params.id)

        const deliveredActivities = await overviewService.getDeliveredActivitiesByClassroom(classroomId)
        const attendance = await overviewService.getAttendanceByClassroom(classroomId)

        const attendance_delivered = await overviewService.getAttendanceActivities(deliveredActivities, attendance)
        const orderned_by_date = attendance_delivered.sort((a, b) => (a.date > b.date) ? 1 : -1)

        response.status(200).json(orderned_by_date)
    }

}


export default new OverviewController()