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
}


export default new OverviewController()